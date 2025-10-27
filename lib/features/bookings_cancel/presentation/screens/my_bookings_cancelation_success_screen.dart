import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/profile_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../user_profile/presantation/screens/edit_personal_profile_screen.dart';

class BookingsCancelationScreen extends StatefulWidget {
  const BookingsCancelationScreen({super.key});

  @override
  State<BookingsCancelationScreen> createState() => _CancelBookingState();
}

class _CancelBookingState extends State<BookingsCancelationScreen> {
  final TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/arrow_back.png',
            height: 24,
            width: 24,
          ),
          onPressed: () {
            Get.offAll(() => const ProfileScreen());
          },
        ),

        title: const Text(
          'My Bookings',
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
              // --- Cancellation Policy ---
              Card(
                elevation: 0,
                margin: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 82,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC8E7CA),
                    border: Border.all(
                      color: const Color(0xFF79C97B),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/success.png',
                        height: 20,
                        width: 20,
                        color: Color(0xFF039A06),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Your booking has been successfully cancelled.",
                          style: TextStyle(
                            color: Color(0xFF039A06),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),
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
