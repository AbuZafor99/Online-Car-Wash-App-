import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/bookings_cancel/presentation/screens/my_bookings_cancelation_success_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user_profile/presantation/screens/edit_personal_profile_screen.dart';

class ConfirmCancalationScreens extends StatefulWidget {
  const ConfirmCancalationScreens({super.key});

  @override
  State<ConfirmCancalationScreens> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<ConfirmCancalationScreens> {
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
      showFloatingActionButton: true,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  'assets/icons/confirmcancelation.png',
                  height: 100,
                  color: Color(0xFFEAB308),
                  cacheHeight: 48,
                  cacheWidth: 48,
                ),
              ),
              const Text(
                "Confirm Cancellation",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Are you absolutely sure you want to cancel this booking? This action cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(height: 44),

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
                        blurRadius: 2,
                        color: AppColors.textGrey.withOpacity(0.2),
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              const SizedBox(height: 50),

              // --- Cancel Booking Button ---
              SizedBox(
                height: 48,
                child: SecondaryButton(
                  text: "",
                  onPressed: () {
                    Get.to(() => const BookingsCancelationScreen());
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
