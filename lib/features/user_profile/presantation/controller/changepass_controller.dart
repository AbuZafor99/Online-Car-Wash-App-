import 'package:get/get.dart';

/// Controller for Change Password Screen
class ChangePasswordController extends GetxController {
  var currentPassword = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs;

  var hasError = false.obs;
  var isSuccess = false.obs;

  void validatePasswords() {
    hasError.value = false;
    isSuccess.value = false;

    if (newPassword.value.length < 12 ||
        !newPassword.value.contains(RegExp(r'[A-Z]')) ||
        !newPassword.value.contains(RegExp(r'[a-z]')) ||
        !newPassword.value.contains(RegExp(r'[0-9]')) ||
        !newPassword.value.contains(RegExp(r'[!@#\$&*~]')) ||
        newPassword.value != confirmPassword.value) {
      hasError.value = true;
    } else {
      isSuccess.value = true;
    }
  }
}
