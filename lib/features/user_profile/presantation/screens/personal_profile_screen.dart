import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/edit_personal_profile_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_buttoms.dart';

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          "Personal Information",
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),

          child: Container(
            height: 650,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Profile Image ---
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textBlue,
                            width: 2,
                          ),
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

                      const SizedBox(height: 10),
                      const Text(
                        'Alex Johnson',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'john.smith@example.com',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Contact Information ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _InfoTile(title: "Phone Number", value: "(555) 123-4567"),
                const SizedBox(height: 24),
                _InfoTile(
                  title: "Email Address",
                  value: "alexjohnson@example.com",
                ),
                const SizedBox(height: 24),
                _InfoTile(
                  title: "Home Address",
                  value: "123 Main Street San Francisco, CA 94105",
                ),
                const SizedBox(height: 20),

                // --- Personal Details ---
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _InfoTile(title: "Date of Birth", value: "1985-06-15"),

                const SizedBox(height: 32),

                // --- Edit Button ---
                SizedBox(
                  height: 39,
                  child: PrimaryButton(
                    text: "Edit Information",
                    onPressed: () {
                      Get.to(() => EditPersonalInformation());
                    },

                    backgroundColor: AppColors.textBlue,
                    textColor: AppColors.primaryWhite,
                    borderRadius: 6,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const _InfoTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textBlack,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
