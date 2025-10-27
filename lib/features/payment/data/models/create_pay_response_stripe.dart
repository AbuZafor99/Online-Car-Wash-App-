import 'package:flutter_youssefkleeno/features/payment/data/models/create_payment_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/utils/debug_print.dart';

abstract class PaymentApiRepository {
  NetworkResult<CreatePaymentApiResponse> createPayment(
    CreatePaymentRequest request,
  );
}

class PaymentApiRepositoryImpl implements PaymentApiRepository {
  final ApiClient _apiClient;

  PaymentApiRepositoryImpl(this._apiClient);

  @override
  NetworkResult<CreatePaymentApiResponse> createPayment(
    CreatePaymentRequest request,
  ) {
    return _apiClient.post<CreatePaymentApiResponse>(
      ApiConstants.payment.createPayment,
      data: request.toJson(),
      fromJsonT: (json) =>
          CreatePaymentApiResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}

class PaymentResponse {
  final String id;
  final String clientSecret;

  PaymentResponse({required this.id, required this.clientSecret});

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    String id = '';
    String clientSecret = '';

    try {
      if (json['data'] is Map) {
        final data = json['data'] as Map<String, dynamic>;
        id =
            data['id']?.toString() ?? data['paymentIntentId']?.toString() ?? '';
        clientSecret =
            data['clientSecret']?.toString() ??
            data['client_secret']?.toString() ??
            '';
      } else {
        id =
            json['id']?.toString() ?? json['paymentIntentId']?.toString() ?? '';
        clientSecret =
            json['clientSecret']?.toString() ??
            json['client_secret']?.toString() ??
            '';
      }

      DPrint.log(
        '✅ Parsed payment response - ID: $id, ClientSecret: ${clientSecret.isNotEmpty}',
      );
    } catch (e) {
      DPrint.error('Error parsing payment response: $e');
    }

    return PaymentResponse(id: id, clientSecret: clientSecret);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'clientSecret': clientSecret};
  }
}

class CreatePaymentApiResponse {
  final String transactionId;

  CreatePaymentApiResponse({required this.transactionId});

  factory CreatePaymentApiResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentApiResponse(transactionId: json['transactionId'] ?? '');
  }
}
