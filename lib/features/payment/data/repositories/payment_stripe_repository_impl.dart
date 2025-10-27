import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/utils/debug_print.dart';
import '../../domain/repositories/payment_repo_stripe.dart';
import '../models/create_pay_request_stripe.dart';
import '../models/create_pay_response_stripe.dart';

class PaymentStripeRepositoryImpl implements PaymentRepository {
  final ApiClient _apiClient;

  PaymentStripeRepositoryImpl(this._apiClient);

  @override
  NetworkResult<PaymentResponse> createPaymentIntent({
    String? transactionId,
    String? userId,
    String? ticketId,
    String? reserveBusId,
    required double amount,
  }) async {
    // Keep original amount as requested - don't convert to cents
    final amountToSend = amount;

    // Backend requires ALL fields together
    // Validate that we have all necessary fields
    if (userId?.isEmpty ?? true) {
      throw Exception('User ID is required');
    }

    if (ticketId?.isEmpty ?? true) {
      throw Exception('Booking ID is required');
    }

    // Build request with ALL required fields for backend
    final request = PaymentRequest(
      amount: amountToSend,
      currency: 'usd',
      transactionId: transactionId, // Can be null for first call
      userId: userId,
      bookingId: ticketId,
    );

    DPrint.log('🔄 Creating Stripe payment intent: ${request.toJson()}');

    return _apiClient.post<PaymentResponse>(
      ApiConstants.payment.createPayment,
      data: jsonEncode(request.toJson()),
      fromJsonT: (json) {
        if (json == null) {
          throw Exception('Payment response is null');
        }
        DPrint.log('📥 Stripe payment response: $json');
        return PaymentResponse.fromJson(json as Map<String, dynamic>);
      },
    );
  }

  @override
  NetworkResult<bool> confirmPayment(String paymentIntentId) {
    return _apiClient.post<bool>(
      ApiConstants.payment.confirmPayment,
      data: jsonEncode({'paymentIntentId': paymentIntentId}),
      fromJsonT: (json) => json['success'] ?? false,
    );
  }

  @override
  NetworkResult<PaymentIntent> processPayment({
    required String clientSecret,
  }) async {
    throw UnimplementedError('Use StripeService.presentPaymentSheet instead');
  }
}
