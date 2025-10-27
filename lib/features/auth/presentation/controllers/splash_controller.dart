import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../screens/onbording_screen1.dart';

class SplashController extends GetxController {
  /// Navigate to onboarding screen. Call this after any animations complete.
  void navigateToOnboarding() {
    Get.off(() => const OnbordingScreen1(), transition: Transition.fadeIn);
  }
}
