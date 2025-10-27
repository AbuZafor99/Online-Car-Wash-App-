import 'package:flutter_youssefkleeno/core/network/network_result.dart';
import 'package:flutter_youssefkleeno/features/payment/data/models/create_payment_model.dart';

abstract class CreatePaymentRepository {
  NetworkResult<CreatePaymentResponse> postPayment(
    CreatePaymentRequest request,
  );
}
