import 'package:flutter_youssefkleeno/features/payment/presentation/controller/payment_controller.dart';
import '../../features/payment/domain/repositories/create_payment_repository.dart';
import '../../features/payment/domain/repositories/payment_repo_stripe.dart';
import 'package:get/get.dart';
import '../../features/subscription/presentation/controllers/booking_controller.dart';
import '../../features/subscription/presentation/controllers/schedule_controller.dart';
import '../../features/subscription/presentation/controllers/vehicle_controller.dart';
import '../../features/subscription/presentation/controllers/location_controller.dart';
// import 'package:karlfive/features/auth/presentation/controller/auth_controller.dart';
// import 'package:karlfive/features/recruiter_account/presentation/controller/recruiter_controller.dart';

void setupController() {
  // Vehicle Controller
  Get.lazyPut<VehicleController>(
    () => VehicleController(Get.find()),
    fenix: true,
  );

  // Schedule Controller
  Get.lazyPut<ScheduleController>(
    () => ScheduleController(Get.find()),
    fenix: true,
  );

  // Location Controller
  Get.lazyPut<LocationController>(() => LocationController(), fenix: true);

  // Booking Controller
  Get.lazyPut<BookingController>(
    () => BookingController(Get.find()),
    fenix: true,
  );

  // Payment Controller (with Stripe repository)
  Get.lazyPut<PaymentController>(
    () => PaymentController(
      Get.find<CreatePaymentRepository>(),
      stripeRepository: Get.find<PaymentRepository>(),
    ),
    fenix: true,
  );

  // Auth Controller
  // Get.lazyPut<AuthController>(
  //   () => AuthController(Get.find(), Get.find()),
  //   fenix: true,
  // );

  // Get.lazyPut<RecruiterController>(
  //   () => RecruiterController(Get.find()),
  //   fenix: true,
  // );
  // Get.lazyPut<VehicleController>(
  //   () => VehicleController(Get.find(), fenix: true),
  // );
}
