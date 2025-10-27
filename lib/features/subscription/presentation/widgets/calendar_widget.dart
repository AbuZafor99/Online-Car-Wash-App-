import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/schedule_controller.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleController>();
    final List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.42,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Calendar Header
            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Obx(() {
                  final isOneTimeWash = controller.isOneTimeWash;
                  final dateText = isOneTimeWash
                      ? 'Select 1 Date'
                      : 'Select 4 Dates';
                  return Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),

            // Week Days Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekDays
                  .map(
                    (day) => Text(
                      day,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),

            // Calendar Grid
            Obx(() {
              // Force rebuild when selectedDates changes
              final selectedDatesSet = controller.selectedDates.toSet();
              print('Calendar rebuilding. Selected dates: $selectedDatesSet');

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: controller.calendarDays.length,
                itemBuilder: (context, index) {
                  final date = controller.calendarDays[index];

                  if (date == null) {
                    return const SizedBox(); // Empty space for days before month starts
                  }

                  final isSelected = selectedDatesSet.contains(date);

                  return GestureDetector(
                    onTap: () => controller.onDateTap(date),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          date.toString(),
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primaryBlue
                                : Colors.white,
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
