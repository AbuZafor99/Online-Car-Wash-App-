import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  void setLoading(bool value) {
    isLoading.value = value;
  }

  void setError(String message) {
    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = '';
  }
}
