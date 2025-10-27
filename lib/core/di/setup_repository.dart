import 'package:flutter_youssefkleeno/features/payment/data/repositories/create_payment_repository_impl.dart';
import 'package:flutter_youssefkleeno/features/payment/data/repositories/payment_stripe_repository_impl.dart';
import 'package:flutter_youssefkleeno/features/payment/domain/repositories/create_payment_repository.dart';
import 'package:flutter_youssefkleeno/features/payment/domain/repositories/payment_repo_stripe.dart';
import 'package:get/get.dart';
import '../../features/subscription/data/repositories/booking_repository_impl.dart';
import '../../features/subscription/data/repositories/schedule_repository_impl.dart';
import '../../features/subscription/data/repositories/vehicle_repository_impl.dart';
import '../../features/subscription/domain/repositories/booking_repository.dart';
import '../../features/subscription/domain/repositories/schedule_repository.dart';
import '../../features/subscription/domain/repositories/vehicle_repository.dart';

void setupRepository() {
  // Vehicle Repository
  Get.lazyPut<VehicleRepository>(
    () => VehicleRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  // Schedule Repository
  Get.lazyPut<ScheduleRepository>(
    () => ScheduleRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  // Booking Repository
  Get.lazyPut<BookingRepository>(
    () => BookingRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  // Payment Repository
  Get.lazyPut<CreatePaymentRepository>(
    () => CreatePaymentRepositoryImpl(apiClient: Get.find()),
    fenix: true,
  );

  // Stripe Payment Repository
  Get.lazyPut<PaymentRepository>(
    () => PaymentStripeRepositoryImpl(Get.find()),
    fenix: true,
  );

  // Get.lazyPut<AuthRepository>(
  //   () => AuthRepositoryImpl(apiClient: Get.find()),
  //   fenix: true,
  // );

  // Get.lazyPut<Repo>(
  //   () => RepoImplementation(apiClient: Get.find()),
  //   fenix: true,
  // );
}
