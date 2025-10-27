import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/schedule_controller.dart';

class SelectedDateCard extends StatelessWidget {
  final int date;
  final int washNumber;

  const SelectedDateCard({
    super.key,
    required this.date,
    required this.washNumber,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScheduleController>();

    return Obx(() {
      final dateInfo = controller.selectedDateDetails[date];
      if (dateInfo == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Text(
              'Wash # $washNumber: ${controller.getFormattedDate(date)}',
              style: const TextStyle(
                color: AppColors.textBlack,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Time Slots and Options
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  // Time Slots Grid
                  _buildTimeSlots(
                    controller,
                    date,
                    dateInfo.scheduleSlot.allSlots,
                  ),

                  _buildWashTypeSelection(controller, date),

                  _buildDottedSeparator(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTimeSlots(
    ScheduleController controller,
    int date,
    List<String> timeSlots,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 3,
      ),
      itemCount: timeSlots.length,
      itemBuilder: (context, index) {
        final timeSlot = timeSlots[index];
        final isSelected = controller.isTimeSlotSelected(date, timeSlot);

        return GestureDetector(
          onTap: () => controller.onTimeSlotSelected(date, timeSlot),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : Colors.grey[100],
              border: Border.all(
                color: isSelected ? AppColors.primaryBlue : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                timeSlot,
                style: TextStyle(
                  color: isSelected ? AppColors.primaryBlue : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWashTypeSelection(ScheduleController controller, int date) {
    return Obx(() {
      final washTypes = controller.washTypes;
      if (washTypes.isEmpty) {
        // Show loading or default while wash types are being fetched
        return Row(
          children: [
            Radio<String>(
              value: 'Steam Wash',
              groupValue: controller.getSelectedWashType(date),
              onChanged: (value) =>
                  controller.onWashTypeChanged(date, value ?? ''),
              activeColor: AppColors.primaryBlue,
            ),
            Text(
              'Steam Wash',
              style: TextStyle(
                color: AppColors.textBlack,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        );
      }

      // Show dynamic wash types based on subscription type in 2 columns
      return LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            children: List.generate(washTypes.length, (index) {
              final washType = washTypes[index];
              return SizedBox(
                width:
                    (constraints.maxWidth - 16) *
                    0.5, // Half width minus margin
                child: InkWell(
                  onTap: () => controller.onWashTypeChanged(date, washType.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8, right: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: washType.id,
                          groupValue: controller.getSelectedWashType(date),
                          onChanged: (value) =>
                              controller.onWashTypeChanged(date, value ?? ''),
                          activeColor: AppColors.primaryBlue,
                        ),
                        Expanded(
                          child: Text(
                            washType.name,
                            style: TextStyle(
                              color: AppColors.textBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      );
    });
  }

  Widget _buildDottedSeparator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          50,
          (index) => Expanded(
            child: Container(
              height: 1,
              color: index % 2 == 0 ? Colors.grey[300] : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
