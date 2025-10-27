import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/custom_app_bar.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:get/get.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/wash_type_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../controllers/vehicle_controller.dart';

class VehicleScreen extends StatefulWidget {
  final String washType;

  const VehicleScreen({super.key, this.washType = 'Monthly Subscription'});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  late final VehicleController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<VehicleController>();
    // Fetch vehicles once when the state is initialized
    controller.fetchVehicles(washType: widget.washType);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: CustomAppBar(title: 'Select Your Vehicle')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Choose the type of vehicle you need to be washed',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryBlue,
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchVehicles(
                            washType: widget.washType,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (!controller.hasVehicles) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No vehicles available',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.vehicles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehicle = controller.vehicles[index];
                    return Obx(() {
                      final isSelected = controller.selectedIndex == index;
                      return GestureDetector(
                        onTap: () => controller.selectVehicle(index),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE8F1F5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryBlue
                                  : const Color(0xffE6E6E6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: vehicle.vehicleImage.url.isNotEmpty
                                      ? Image.network(
                                          vehicle.vehicleImage.url,
                                          height: 24,
                                          width: 24,
                                          fit: BoxFit.cover,
                                          errorBuilder: (c, e, s) => const Icon(
                                            Icons.directions_car,
                                            color: AppColors.primaryBlue,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.directions_car,
                                          color: AppColors.primaryBlue,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  vehicle.vehicleName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryBlue,
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            Obx(() {
              final canContinue = controller.canContinue;
              return PrimaryButton(
                onPressed: canContinue
                    ? () {
                        final selected = controller.selectedVehicle;
                        if (selected == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a vehicle'),
                            ),
                          );
                          return;
                        }

                        // Store selected vehicle in BookingController
                        final bookingController = Get.find<BookingController>();
                        bookingController.vehicleId = selected.id;
                        bookingController.vehicleType = selected.vehicleName;

                        // Navigate to WashTypeScreen after a vehicle is selected
                        Get.to(
                          () => WashTypeScreen(washType: widget.washType),
                          transition: Transition.rightToLeft,
                        );
                      }
                    : () {
                        // Show a message to select a vehicle
                      },
                text: canContinue ? 'Continue' : 'Select a vehicle',
                backgroundColor: canContinue
                    ? AppColors.primaryBlue
                    : AppColors.primaryBlue.withOpacity(0.4),
              );
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }
}
