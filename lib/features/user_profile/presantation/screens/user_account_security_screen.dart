import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controller/changepass_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final ChangePasswordController controller = Get.put(
    ChangePasswordController(),
  );

  final TextEditingController currentCtrl = TextEditingController();
  final TextEditingController newCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  get child => null;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          "Account Security",
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        // centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                /// Fields
                Obx(
                  () => _passwordField(
                    label: "Current Password",
                    controller: currentCtrl,
                    onChanged: (val) => controller.currentPassword.value = val,
                    hasError: controller.hasError.value,
                  ),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => _passwordField(
                    label: "New Password",
                    controller: newCtrl,
                    onChanged: (val) => controller.newPassword.value = val,
                    hasError: controller.hasError.value,
                  ),
                ),
                const SizedBox(height: 24),

                Obx(
                  () => _passwordField(
                    label: "Confirm Password",
                    controller: confirmCtrl,
                    onChanged: (val) => controller.confirmPassword.value = val,
                    hasError: controller.hasError.value,
                  ),
                ),

                const SizedBox(height: 24),

                /// Error message
                /// Error message
                Obx(
                  () => controller.hasError.value
                      ? const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              "Passphrase must be at least 12 characters and \n include one uppercase, one lowercase, one number, \n and one special character.",
                              style: TextStyle(
                                color: Color(0xFFB90000),
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.validatePasswords();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF499FC0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Update Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Success message
                Obx(
                  () => controller.isSuccess.value
                      ? const Text(
                          "Password Changed Successfully",
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _passwordField({
  required TextEditingController controller,
  required Function(String) onChanged,
  required bool hasError,
  String? label,
  double height = 53,
}) {
  final isObscure = true.obs;

  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Static label above the box ---
        if (label != null) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: 12),
        ],

        // --- Password field ---
        Obx(
          () => SizedBox(
            height: height,
            child: TextFormField(
              controller: controller,
              obscureText: isObscure.value,
              obscuringCharacter: "*",
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212121),
              ),
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Image.asset(
                    isObscure.value
                        ? "assets/icons/eye_close.png"
                        : "assets/icons/eye_open.png",
                    width: 20,
                    height: 20,
                    color: const Color(0xFF999999),
                  ),
                  onPressed: () {
                    isObscure.value = !isObscure.value;
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFFD8D8D8B2),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(
                    color: hasError ? Colors.red : const Color(0xFF4B5563),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
