import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../../../../core/utils/debug_print.dart';

class StripeService {
  StripeService._();
  static final instance = StripeService._();

  Future<bool> presentPaymentSheet({
    required String clientSecret,
    String merchantDisplayName = 'KarlFive',
    ThemeMode style = ThemeMode.dark,
  }) async {
    try {
      DPrint.info('StripeService.presentPaymentSheet init with clientSecret');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          style: style,
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      DPrint.info('StripeService.presentPaymentSheet success');
      return true;
    } on StripeException catch (e) {
      DPrint.error('Stripe Exception: ${e.error.localizedMessage}');
      return false;
    } catch (e, st) {
      DPrint.error('Stripe error: $e\n$st');
      return false;
    }
  }
}
