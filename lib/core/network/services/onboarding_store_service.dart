import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutx_core/flutx_core.dart';

import '../constants/key_constants.dart';

class OnboardingStoreService {
  final FlutterSecureStorage _secureStorage;

  OnboardingStoreService({FlutterSecureStorage? storage})
    : _secureStorage = storage ?? const FlutterSecureStorage();

  // Store onboarding data
  Future<void> storeOnboardingData({required String isCompleted}) async {
    await _secureStorage.write(
      key: KeyConstants.onboardingStatus,
      value: isCompleted,
    );
  }

  // Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final onboardingStatus = await _secureStorage.read(
        key: KeyConstants.onboardingStatus,
      );
      // Return true if the value exists and equals "true", otherwise false
      return onboardingStatus == "true";
    } catch (e) {
      DPrint.error("Error reading onboarding status: $e");
      return false;
    }
  }

  // Clear onboarding data
  Future<void> clearOnboardingData() async {
    await _secureStorage.delete(key: KeyConstants.onboardingStatus);
  }
}
