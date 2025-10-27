import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_buttoms.dart';

class EditPersonalInformation extends StatelessWidget {
  const EditPersonalInformation({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController dobController = TextEditingController(
      text: "1985-06-15",
    );

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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Profile Image + Info ---
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // --- Profile Image ---
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.textBlue,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/profileimage.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // --- Image Picker Overlay Button ---
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                // image picker functionality (placeholder for now)
                                Get.snackbar(
                                  "Change Profile Picture",
                                  "Image picker coming soon!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.white,
                                  colorText: AppColors.textBlue,
                                );
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.textBlue,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Alex Johnson',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'john.smith@example.com',
                        textAlign: TextAlign.center,
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
                const Text(
                  'Contact Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(label: "Full Name", hintText: "Alex Johnson"),
                _buildTextField(
                  label: "Email",
                  hintText: "alexjohnson@example.com",
                ),
                _buildTextField(
                  label: "Street Address",
                  hintText: "123 Main Street",
                ),

                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: "City",
                        hintText: "San Francisco",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(label: "State", hintText: "CA"),
                    ),
                  ],
                ),
                _buildTextField(label: "Zip Code", hintText: "94105"),

                const SizedBox(height: 20),

                // --- Personal Details ---
                const Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlack,
                  ),
                ),
                const SizedBox(height: 12),

                // --- Date of Birth Field with Picker ---
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date of Birth",
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_today_outlined,
                            size: 18,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: AppColors.textBlue,
                              width: 1.2,
                            ),
                          ),
                        ),
                        onTap: () async {
                          FocusScope.of(
                            context,
                          ).requestFocus(FocusNode()); // hide keyboard
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(1985, 6, 15),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors
                                        .textBlue, // calendar header color
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.textBlack,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (pickedDate != null) {
                            // format the date (YYYY-MM-DD)
                            final formattedDate =
                                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                            dobController.text = formattedDate;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // --- Buttons Row ---
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 43,
                        child: SecondaryButton(
                          onPressed: () => Get.back(),
                          text: "Cancel",
                          textColor: AppColors.textBlue,
                          borderColor: AppColors.textBlue,
                          borderRadius: 6,
                          // textStyle: const TextStyle(
                          //   fontSize: 14,
                          //   fontWeight: FontWeight.w500,
                          // ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 43,
                        child: PrimaryButton(
                          text: "Save Changes",
                          onPressed: () {},
                          backgroundColor: AppColors.textBlue,
                          textColor: AppColors.primaryWhite,
                          borderRadius: 6,
                          // textStyle: const TextStyle(
                          //   fontSize: 14,
                          //   fontWeight: FontWeight.w500,
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable Text Field ---
  Widget _buildTextField({required String label, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.textBlue,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
