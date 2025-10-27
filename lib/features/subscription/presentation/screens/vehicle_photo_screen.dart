import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/schedule_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';
import '../controllers/booking_controller.dart';
import '../controllers/vehicle_photo_controller.dart';

class VehiclePhotoScreen extends StatelessWidget {
  final String washType;

  const VehiclePhotoScreen({super.key, this.washType = 'Monthly Subscription'});

  @override
  Widget build(BuildContext context) {
    final VehiclePhotoController controller = Get.put(VehiclePhotoController());

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Vehicle Photo',
          style: TextStyle(
            color: AppColors.textBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Upload your vehicle photo here',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.showImagePickerOptions(context),
                    child: DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        radius: const Radius.circular(10),
                        dashPattern: const [5, 5],
                        strokeWidth: 1,
                        color: AppColors.textGrey.withOpacity(0.3),
                      ),
                      child: Obx(
                        () => Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.23,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: controller.selectedImage.value != null
                              ? Stack(
                                  children: [
                                    // Display selected image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        controller.selectedImage.value!,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Remove button
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: controller.clearImage,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Center(
                                  child: controller.isLoading.value
                                      ? CircularProgressIndicator(
                                          color: AppColors.primaryBlue,
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.camera_alt_outlined,
                                              color: AppColors.textBlack,
                                              size: 50,
                                            ),
                                            SizedBox(height: 14),
                                            Text(
                                              'Take Photo or Upload',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textBlue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Tap to add vehicle photos',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppColors.textGrey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'License Plate Number',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller.licensePlateController,
                    onChanged: controller.updateLicensePlate,
                    decoration: InputDecoration(
                      hintText: 'Enter your plate number',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondaryBlack,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Color(0xffB1B3B4)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Color(0xffB1B3B4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => PrimaryButton(
              onPressed: () {
                if (controller.canContinue) {
                  // Store vehicle photo and license plate in BookingController
                  final bookingController = Get.find<BookingController>();
                  bookingController.carPhoto = controller.selectedImage.value;
                  bookingController.licensePlate = controller.licensePlate.value
                      .trim();

                  // Navigate to schedule screen
                  Get.to(
                    () => ScheduleScreen(subscriptionType: washType),
                    transition: Transition.rightToLeft,
                  );
                } else {
                  // Show validation feedback
                  String message = '';
                  if (controller.selectedImage.value == null &&
                      controller.licensePlate.value.trim().isEmpty) {
                    message =
                        'Please upload a vehicle photo and enter license plate number.';
                  } else if (controller.selectedImage.value == null) {
                    message = 'Please upload a vehicle photo to continue.';
                  } else {
                    message = 'Please enter license plate number to continue.';
                  }

                  Get.snackbar(
                    'Missing Information',
                    message,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                }
              },
              // visually indicate disabled state when requirements not met
              backgroundColor: controller.canContinue
                  ? AppColors.primaryBlue
                  : AppColors.primaryBlue,
              text: 'Continue',
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }
}
