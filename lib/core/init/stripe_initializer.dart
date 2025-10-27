import 'package:flutx_core/flutx_core.dart';
import '../common/constants/stripe_key.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeInitializer {
  static Future<void> intiStripe() async {
    DPrint.log(
      '🔧 Initializing Stripe with publishable key: ${StripeKey.publishableKey.substring(0, 20)}...',
    );

    Stripe.publishableKey = StripeKey.publishableKey;
    // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';

    try {
      await Stripe.instance.applySettings();
      DPrint.log('✅ Stripe initialized successfully');
    } catch (e) {
      DPrint.error('❌ Stripe initialization failed: $e');
    }
  }
}
