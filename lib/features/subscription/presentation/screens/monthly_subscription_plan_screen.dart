import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/vehicle_screen.dart';
import 'package:get/get.dart';
import '../../../../core/common/widgets/custom_app_bar.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';

class MonthlySubscriptionPlanScreen extends StatelessWidget {
  const MonthlySubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: CustomAppBar(title: 'Monthly Subscription')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your subscription plan',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 32.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Your Wash Plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '\$29',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '/month',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildFeatureItem(
                              '4 washes per month (1 per week)',
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureItem(
                              'Choose your preferred dates and times',
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureItem('Flexibility to change schedule'),
                            const SizedBox(height: 12),
                            _buildFeatureItem('1 deep cleaning session'),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // Get booking controller and auth service
                                  final bookingController =
                                      Get.find<BookingController>();
                                  final authService =
                                      Get.find<AuthStorageService>();

                                  // Get userId from secure storage (will use default if not authenticated)
                                  final userId = await authService.getUserId();

                                  if (userId == null || userId.isEmpty) {
                                    Get.snackbar(
                                      'Error',
                                      'Unable to get user information. Please try again.',
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  // Initialize booking data for Monthly Subscription
                                  bookingController.userId = userId;
                                  bookingController.amount = 29.0;
                                  bookingController.subscriptionType =
                                      'Monthly Subscription';

                                  // Navigate to vehicle screen with Monthly Subscription wash type
                                  Get.to(
                                    () => const VehicleScreen(
                                      washType: 'Monthly Subscription',
                                    ),
                                    transition: Transition.rightToLeft,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primaryBlue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Subscribe Now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () async {
                                    // Get booking controller and auth service
                                    final bookingController =
                                        Get.find<BookingController>();
                                    final authService =
                                        Get.find<AuthStorageService>();

                                    // Get userId from secure storage (will use default if not authenticated)
                                    final userId = await authService
                                        .getUserId();

                                    if (userId == null || userId.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'Unable to get user information. Please try again.',
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // Initialize booking data for One-time Wash
                                    bookingController.userId = userId;
                                    bookingController.amount =
                                        0.0; // Will be set based on wash type
                                    bookingController.subscriptionType =
                                        'One-time Wash';

                                    // Navigate to vehicle screen with One-time Wash wash type
                                    Get.to(
                                      () => const VehicleScreen(
                                        washType: 'One-time Wash',
                                      ),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Text(
                                    'Switch to One-time Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.white,
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
                ],
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      children: [
        Icon(Icons.check, color: Color(0xffB1E0B2), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
