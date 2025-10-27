import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/schedule_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user_profile/presantation/screens/edit_personal_profile_screen.dart';
import 'cancel_booking_screen.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({super.key});

  @override
  State<BookingDetails> createState() => _ConfirmedState();
}

class _ConfirmedState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Booking Details',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      const Text(
                        'Booking #  Bk9520 ',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEF6E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/confirmed.png',
                          height: 14,
                          width: 14,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Confirmed",
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Card(
                child: Container(
                  height: 571,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Water Wash',
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
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/home.png',
                            color: AppColors.textBlack,
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
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
                      Row(
                        children: [
                          const SizedBox(width: 28),
                          Text(
                            'Home: 123 Main St',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/vehicle.png',
                            color: AppColors.textBlack,
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
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
                      Row(
                        children: [
                          const SizedBox(width: 28),
                          Text(
                            'Car',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Divider(color: Color(0xFF428FAD)),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Total Paid',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textBlack,
                            ),
                          ),

                          const SizedBox(width: 16),
                          Text(
                            '\$29',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 34),

              // --- Modify Booking Button ---
              SizedBox(
                height: 50,
                child: SecondaryButton(
                  text: "",
                  onPressed: () {
                    Get.to(() => ScheduleScreen());
                  },
                  backgroundColor: AppColors.textBlue,
                  textColor: AppColors.primaryWhite,
                  borderRadius: 6,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/editbooking.png',
                        height: 18,
                        width: 18,
                        color: AppColors.primaryWhite,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Modify Booking",
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

              const SizedBox(height: 10),

              // --- Cancel Booking Button ---
              SizedBox(
                height: 50,
                child: SecondaryButton(
                  text: "", // ignored because we use child
                  onPressed: () {
                    Get.to(() => CancelBooking());
                  },
                  backgroundColor: AppColors.pdfContainerBackground,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textBlack,
              size: 20,
            ),
            const SizedBox(width: 8),
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
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 28),
            Text(
              '8:00 AM-10:00 AM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B6B6B),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
