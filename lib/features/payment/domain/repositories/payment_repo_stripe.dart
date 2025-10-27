import 'package:flutter_stripe/flutter_stripe.dart';

import '../../../../core/network/network_result.dart';
import '../../data/models/create_pay_response_stripe.dart';

abstract class PaymentRepository {
  NetworkResult<PaymentResponse> createPaymentIntent({
    /// The transaction id returned from backend (preferred).
    String? transactionId,

    /// The user id (fallback if transactionId is not available).
    String? userId,

    String? ticketId,
    String? reserveBusId,

    /// Amount in major currency units (e.g., dollars). Implementation
    /// should convert to cents safely.
    required double amount,
  });

  // Confirm payment on server using paymentIntent id
  NetworkResult<bool> confirmPayment(String paymentIntentId);

  NetworkResult<PaymentIntent> processPayment({required String clientSecret});
}
