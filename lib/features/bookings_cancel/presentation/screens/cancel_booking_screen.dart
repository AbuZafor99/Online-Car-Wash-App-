import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/bookings_cancel/presentation/screens/confirm_cancelation_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user_profile/presantation/screens/edit_personal_profile_screen.dart';

class CancelBooking extends StatefulWidget {
  const CancelBooking({super.key});

  @override
  State<CancelBooking> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<CancelBooking> {
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'Cancel Booking',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/cancel_bookings.png',
                  height: 100,
                  color: Color(0xFFEF4444),
                  cacheHeight: 48,
                  cacheWidth: 48,
                ),
              ),
              const Text(
                "Cancel Your Booking",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Are you sure you want to cancel your car wash booking?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 44),

              // --- Booking Details ---
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 4,
                        color: AppColors.textGrey.withOpacity(0.2),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildWashTime(),
                      const SizedBox(height: 16),
                      _buildWashTime(),
                      const SizedBox(height: 16),
                      _buildWashTime(),
                      const SizedBox(height: 16),
                      _buildWashTime(),
                      const SizedBox(height: 16),

                      // --- Location ---
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/home.png',
                            color: AppColors.textBlack,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Location',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 28),
                        child: Text(
                          'Home: 123 Main St',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // --- Vehicle ---
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/vehicle.png',
                            color: AppColors.textBlack,
                            height: 22,
                            width: 22,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Vehicle',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.only(left: 28),
                        child: Text(
                          'Car',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Cancellation Policy ---
              Card(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1,
                        blurRadius: 4,
                        color: AppColors.textGrey.withOpacity(0.2),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cancellation Policy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Our cancellation policy is as follows:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          spacing: 4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "\u2022\u00A0More than 24 hours before: Full refund",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              "\u2022\u00A012–24 hours before: 75% refund",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              "\u2022\u00A04–12 hours before: 50% refund",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              "\u2022\u00A02–4 hours before: 25% refund",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                              ),
                            ),
                            Text(
                              "\u2022\u00A0Less than 2 hours before: No refund",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Color(0xFFE1E1E2), thickness: 1),
                      const SizedBox(height: 8),

                      // --- Payment Info ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Original Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlack,
                            ),
                          ),
                          Text(
                            '\$29.00',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Cancellation Fee',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlack,
                            ),
                          ),
                          Text(
                            '-\$00.00',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: Color(0xFFE1E1E2), thickness: 1),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Refund Amount',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                          Text(
                            '\$29.00',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // --- Reason for Cancellation ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reason for Cancellation",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Please tell us why you're cancelling...",
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(
                      color: Color(0xFFDDDDDD),
                      width: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 34),

              // --- Cancel Booking Button ---
              SizedBox(
                height: 48,
                child: SecondaryButton(
                  text: "",
                  onPressed: () {
                    Get.to(() => const ConfirmCancalationScreens());
                  },
                  backgroundColor: AppColors.deleteButtonBackground,
                  textColor: AppColors.primaryWhite,
                  borderRadius: 6,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/cancel.png',
                        height: 18,
                        width: 18,
                        color: AppColors.primaryWhite,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Cancel Booking",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWashTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textBlack,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Wash # 1: 02/06/2025',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            '8:00 AM - 10:00 AM',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B6B6B),
            ),
          ),
        ),
      ],
    );
  }
}
