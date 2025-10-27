import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/screens/payment.dart';
import 'package:flutter_youssefkleeno/features/payment/presentation/controller/payment_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/custom_app_bar.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../../../core/utils/debug_print.dart';
import '../controllers/booking_controller.dart';
import '../controllers/schedule_controller.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/selected_date_card.dart';

class ScheduleScreen extends StatelessWidget {
  final String? subscriptionType;

  const ScheduleScreen({super.key, this.subscriptionType});

  /// Initialize BookingController with default values if not already set
  void _initializeBookingController() async {
    final bookingController = Get.find<BookingController>();

    // If userId is not set, get it from AuthStorageService
    if (bookingController.userId == null || bookingController.userId!.isEmpty) {
      final authService = Get.find<AuthStorageService>();
      final userId = await authService.getUserId();
      if (userId != null && userId.isNotEmpty) {
        bookingController.userId = userId;
        DPrint.log('🔧 Auto-initialized userId: $userId');
      }
    }

    // If subscription type is not set, set it from the parameter
    if (bookingController.subscriptionType == null ||
        bookingController.subscriptionType!.isEmpty) {
      bookingController.subscriptionType =
          subscriptionType ?? 'Monthly Subscription';
      DPrint.log(
        '🔧 Auto-initialized subscriptionType: ${bookingController.subscriptionType}',
      );
    }

    // If amount is not set, set default based on subscription type
    if (bookingController.amount == null) {
      final isOneTime =
          subscriptionType?.toLowerCase().contains('one-time') == true;
      bookingController.amount = isOneTime ? 0.0 : 29.0;
      DPrint.log('🔧 Auto-initialized amount: ${bookingController.amount}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the controller from DI
    final controller = Get.find<ScheduleController>();

    // Initialize BookingController with defaults if not set
    _initializeBookingController();

    // Ensure subscription type is set immediately so controller state is in sync
    // with widgets that may read it during the first build (avoids timing/race issues).
    controller.setSubscriptionType(subscriptionType ?? 'Monthly Subscription');

    // Determine UI text based on controller's subscription type so UI and
    // controller remain consistent.
    final isOneTime = controller.isOneTimeWash;
    final title = isOneTime ? "Schedule Your Wash" : "Schedule Your 4 Washes";
    final subtitle = isOneTime
        ? "Select 1 date and time from this month"
        : "Select 4 dates and times from this month";

    return AppScaffold(
      appBar: AppBar(title: CustomAppBar(title: title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textBlack,
              ),
            ),
            const SizedBox(height: 16),

            // Calendar Widget
            const CalendarWidget(),

            const SizedBox(height: 16),

            // Loading indicator
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Selected Dates and Time Slots
            Obx(() {
              final selectedDatesList = controller.selectedDatesList;

              if (selectedDatesList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      'Select dates from the calendar above',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  // Selected date cards
                  ...selectedDatesList.asMap().entries.map((entry) {
                    final index = entry.key;
                    final date = entry.value;

                    return SelectedDateCard(date: date, washNumber: index + 1);
                  }),

                  const SizedBox(height: 24),

                  // Continue Button - Always visible but enabled/disabled based on selection
                  Obx(() {
                    final canProceed = controller.canProceed;

                    return Opacity(
                      opacity: canProceed ? 1.0 : 0.5,
                      child: AbsorbPointer(
                        absorbing: !canProceed,
                        child: PrimaryButton(
                          onPressed: () async {
                            if (canProceed) {
                              // Get the booking controller
                              final bookingController =
                                  Get.find<BookingController>();

                              // DEBUG: Log booking controller state before creating booking
                              print(
                                '🔍 ========== SCHEDULE SCREEN DEBUG ==========',
                              );
                              print(
                                '👤 BookingController userId: ${bookingController.userId}',
                              );
                              print(
                                '🚗 BookingController vehicleId: ${bookingController.vehicleId}',
                              );
                              print(
                                '📍 BookingController location: ${bookingController.locationAddress}',
                              );
                              print(
                                '📷 BookingController carPhoto: ${bookingController.carPhoto?.path}',
                              );
                              print(
                                '🔢 BookingController licensePlate: ${bookingController.licensePlate}',
                              );
                              print(
                                '🔍 ============================================',
                              );

                              // Prepare scheduled dates for booking
                              final scheduledDates = <Map<String, dynamic>>[];
                              final now = DateTime.now();

                              for (final dateInfo
                                  in controller.selectedDateDetails.values) {
                                // Create DateTime from the day number
                                final selectedDate = DateTime(
                                  controller.currentYear.value,
                                  now.month,
                                  dateInfo.date,
                                );

                                // Format date as ISO 8601 with timezone (matching backend format)
                                final formattedDate = selectedDate
                                    .toUtc()
                                    .toIso8601String();

                                scheduledDates.add({
                                  'date': formattedDate,
                                  'slot': dateInfo.selectedTimeSlot ?? '',
                                  'washTypeId': dateInfo.washType,
                                });
                              }

                              print(
                                '📅 Prepared scheduled dates: $scheduledDates',
                              );

                              // Set scheduled dates in booking controller
                              bookingController.scheduledDates = scheduledDates;

                              // Create booking
                              await bookingController.createBooking();

                              // Check if booking was successful
                              if (bookingController.bookingResponse != null) {
                                // Set payment controller data from booking response
                                try {
                                  final paymentController =
                                      Get.find<PaymentController>();
                                  paymentController.setFromBooking(
                                    bookingController.bookingResponse!,
                                  );
                                } catch (e) {
                                  // If PaymentController not found in DI, just continue
                                  DPrint.log(
                                    '⚠️ PaymentController not found in DI: $e',
                                  );
                                }

                                // Navigate to payment screen with booking data
                                Get.to(() => Payment());
                              }
                            }
                          },
                          text: 'Continue',
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 40), // Bottom padding for scroll
                ],
              );
            }),
          ],
        ),
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }
}
