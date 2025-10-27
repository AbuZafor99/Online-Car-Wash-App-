import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/bookings_cancel/presentation/screens/empty_booking_screen.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/TermsandCondition_screen.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/personal_profile_screen.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/privacy_policy_screen.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/user_account_security_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_buttoms.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../bookings_cancel/presentation/screens/my_bookings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ---- Profile Header ----
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(14),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image with border
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textBlue, width: 2),
                      ),
                      child: ClipOval(
                        child: Center(
                          child: Image.asset(
                            'assets/images/profileimage.png',
                            fit: BoxFit.cover,
                            width: 80,
                            height: 90,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text info
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Alex Johnson',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlue,
                            ),
                          ),
                          const SizedBox(height: 11),
                          Text(
                            'john.smith@example.com',
                            style: TextStyle(
                              color: Color(0xFF363636),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '(555) 123-4567',
                            style: TextStyle(
                              color: Color(0xFF363636),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ---- Profile Options ----
              SizedBox(
                height: 350,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(10),
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
                      _ProfileOption(
                        iconPath: 'assets/icons/profile.png',
                        title: "Personal Information",
                        iconColor: AppColors.textBlue,
                        onTap: () {
                          Get.to(() => PersonalProfileScreen());
                        },
                      ),
                      const SizedBox(height: 10),
                      _ProfileOption(
                        iconPath: 'assets/icons/security.png',
                        title: "Account Security",
                        iconColor: AppColors.primaryLightBlue,
                        onTap: () {
                          Get.to(() => ChangePasswordScreen());
                        },
                      ),
                      const SizedBox(height: 10),
                      _ProfileOption(
                        iconPath: 'assets/icons/bookings.png',
                        title: "My Bookings",
                        iconColor: Colors.orangeAccent,
                        onTap: () {
                          // Example booking list check
                          // final List<dynamic> bookings = []; // Replace with your actual bookings list or API data
                          //
                          // if (bookings.isNotEmpty) {
                          //   Get.to(() => MyBookingsScreen());
                          // }
                          // else {
                          //   Get.to(() => const EmptyBookingsScreen());
                          // }
                          Get.to(() => MyBookingsScreen());
                        },
                      ),

                      const SizedBox(height: 10),
                      _ProfileOption(
                        iconPath: 'assets/icons/privacy.png',
                        title: "Privacy Policy",
                        iconColor: Colors.green,
                        onTap: () {
                          Get.to(() => PrivacyPolicyScreen());
                        },
                      ),
                      const SizedBox(height: 10),
                      _ProfileOption(
                        iconPath: 'assets/icons/terms.png',
                        title: "Terms & Conditions",
                        iconColor: Colors.redAccent,
                        onTap: () {
                          Get.to(() => TermsandConditions());
                        },
                      ),
                      _ProfileOption(
                        iconPath: 'assets/icons/terms.png',
                        title: "Empty Booking",
                        iconColor: Colors.redAccent,
                        onTap: () {
                          Get.to(() => EmptyBookingsScreen());
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---- Logout Button ----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SecondaryButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Log Out",
                      middleText: "Are you sure you want to log out?",
                      textConfirm: "Yes",
                      textCancel: "Cancel",
                      confirmTextColor: Colors.white,
                      buttonColor: AppColors.deleteButtonBackground,
                      onConfirm: () => Get.back(),
                    );
                  },

                  text: "Log Out",
                  textColor: AppColors.deleteButtonBackground,
                  borderColor: AppColors.deleteButtonBackground,
                  borderRadius: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/logout.png',
                        height: 18,
                        width: 20,
                        color: AppColors.deleteButtonBackground,
                      ),
                      const SizedBox(width: 18),
                      const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.deleteButtonBackground,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- Reusable Option Tile ----
class _ProfileOption extends StatelessWidget {
  final String iconPath;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.iconPath,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        iconPath,
        height: 22,
        width: 22,
        color: AppColors.iconColor,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textBlack,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        color: Color(0xFF9CA3AF),
        size: 14,
      ),
      onTap: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}
