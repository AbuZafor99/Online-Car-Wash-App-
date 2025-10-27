import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'bookings_details_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: const BackButton(color: Colors.black),
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "My Bookings",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        centerTitle: false,
      ),
      showFloatingActionButton: true,
      onFabTap: () {
        // Handle navigation to profile or action
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          /// --- Booking Card ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
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
                /// --- Row: Service title + Status badge ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/calender_circle.png',
                          height: 26,
                          width: 26,
                          color: AppColors.textBlue,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Subscription Wash',
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

                const SizedBox(height: 14),

                /// --- Total Paid ---
                const Text.rich(
                  TextSpan(
                    text: "Total Paid ",
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 13.5,
                    ),
                    children: [
                      TextSpan(
                        text: "\$29",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// --- Booking ID ---
                GestureDetector(
                  onTap: () {
                    Get.to(() => const BookingDetails());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text.rich(
                        TextSpan(
                          text: "Booking ID ",
                          style: TextStyle(
                            color: AppColors.textBlack,
                            fontSize: 13.5,
                          ),
                          children: [
                            TextSpan(
                              text: "BK9520",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xFF9CA3AF),
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
