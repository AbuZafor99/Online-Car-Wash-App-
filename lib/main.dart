import 'package:flutter/material.dart';
// Keep imports minimal for main entry
import 'package:get/get.dart';
import 'core/bottomNavbar/controllers/bottom_nav_controller.dart';
import 'core/init/app_initializer.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/common/constants/stripe_key.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() async {
  // App initialize
  await AppInitializer.initializeApp();

  // Inject BottomNavCon troller globally
  Get.put(BottomNavController());

  // Initialize Stripe SDK
  try {
    Stripe.publishableKey = StripeKey.publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.youssefkleeno';
    await Stripe.instance.applySettings();
  } catch (e) {
    // Log but don't block app startup
    // Use existing debug util if available
    // ignore: avoid_print
    print('Stripe init error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YoussefKleeno',
      theme: AppTheme.light,
      home: SplashScreen(),
    );
  }
}
