import 'package:flutter_youssefkleeno/core/network/api_client.dart';
import 'package:flutter_youssefkleeno/core/network/constants/api_constants.dart';
import 'package:flutter_youssefkleeno/core/network/network_result.dart';
import 'package:flutter_youssefkleeno/features/payment/data/models/create_payment_model.dart';
import 'package:flutter_youssefkleeno/features/payment/domain/repositories/create_payment_repository.dart';

class CreatePaymentRepositoryImpl implements CreatePaymentRepository {
  final ApiClient _apiClient;

  CreatePaymentRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<CreatePaymentResponse> postPayment(
    CreatePaymentRequest request,
  ) {
    final requestData = request.toJson();
    print('🚀 Sending payment request to: ${ApiConstants.payment.createPayment}');
    print('📦 Request payload: $requestData');
    
    return _apiClient.post(
      ApiConstants.payment.createPayment,
      fromJsonT: (json) => CreatePaymentResponse.fromJson(json),
      data: requestData, // Send as Map, not JSON string
    );
  }
}
