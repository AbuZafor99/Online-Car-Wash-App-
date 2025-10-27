import 'dart:io';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/debug_print.dart';
import '../../data/models/booking_request_model.dart';
import '../../data/models/booking_response_model.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingController extends BaseController {
  final BookingRepository _repository;

  BookingController(this._repository);

  // Observable booking response
  final Rx<BookingResponseModel?> _bookingResponse = Rx<BookingResponseModel?>(
    null,
  );
  BookingResponseModel? get bookingResponse => _bookingResponse.value;

  // Booking data collected throughout the flow
  String? subscriptionType;
  String? userId;
  double? amount;
  String? vehicleId;
  String? vehicleType;
  String? locationAddress;
  double? locationLat;
  double? locationLng;
  File? carPhoto;
  String? licensePlate;
  List<Map<String, dynamic>>? scheduledDates; // date, slot, washTypeId

  /// Create booking with all collected data
  Future<void> createBooking() async {
    try {
      // Log all collected data for debugging
      DPrint.log('🔍 ============ BOOKING DATA DEBUG ============');
      DPrint.log('📋 Booking Type: $subscriptionType');
      DPrint.log('👤 User ID: $userId');
      DPrint.log('💰 Amount: $amount');
      DPrint.log('🚗 Vehicle ID: $vehicleId');
      DPrint.log('🚙 Vehicle Type: $vehicleType');
      DPrint.log('📍 Location Address: $locationAddress');
      DPrint.log('🌍 Location Lat: $locationLat');
      DPrint.log('🌍 Location Lng: $locationLng');
      DPrint.log('📷 Car Photo: ${carPhoto?.path ?? "No photo"}');
      DPrint.log('🔢 License Plate: $licensePlate');
      DPrint.log('📅 Scheduled Dates: $scheduledDates');
      DPrint.log('🔍 ============================================');

      // Validate all required data
      if (userId == null || userId!.isEmpty) {
        setError('User ID is required');
        DPrint.log('❌ Validation failed: User ID is null or empty');
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      if (vehicleId == null || vehicleId!.isEmpty) {
        setError('Vehicle is required');
        Get.snackbar('Error', 'Please select a vehicle');
        return;
      }

      if (locationAddress == null ||
          locationLat == null ||
          locationLng == null) {
        setError('Location is required');
        Get.snackbar('Error', 'Please select a location');
        return;
      }

      if (licensePlate == null || licensePlate!.isEmpty) {
        setError('License plate is required');
        Get.snackbar('Error', 'Please enter license plate number');
        return;
      }

      if (scheduledDates == null || scheduledDates!.isEmpty) {
        setError('Schedule dates are required');
        Get.snackbar('Error', 'Please select schedule dates');
        return;
      }

      setLoading(true);
      setError('');

      // Build location data
      final location = LocationData(
        address: locationAddress!,
        lat: locationLat!,
        lng: locationLng!,
      );

      // Build dates array
      final dates = scheduledDates!.map((dateData) {
        return BookingDateSlot(
          date: dateData['date'] as String,
          slot: dateData['slot'] as String,
          washTypeId: dateData['washTypeId'] as String,
        );
      }).toList();

      // Determine booking type
      final bookingType =
          subscriptionType?.toLowerCase().contains('one-time') == true
          ? 'one-time'
          : 'subscription';

      // Create booking request
      final request = BookingRequestModel(
        userId: userId!,
        bookingType: bookingType,
        licensePlate: licensePlate!,
        location: location,
        vehicleId: vehicleId!,
        dates: dates,
        carPhoto: carPhoto,
      );

      // Log request details
      DPrint.log('📤 ============ API REQUEST DEBUG ============');
      DPrint.log('🔗 Endpoint: POST /booking');
      DPrint.log('👤 User ID: ${request.userId}');
      DPrint.log('📋 Booking Type: ${request.bookingType}');
      DPrint.log('🔢 License Plate: ${request.licensePlate}');
      DPrint.log('🚗 Vehicle ID: ${request.vehicleId}');
      DPrint.log('📍 Location: ${location.toJsonString()}');
      DPrint.log('📅 Dates (${dates.length} items):');
      for (var i = 0; i < dates.length; i++) {
        DPrint.log(
          '   [$i] Date: ${dates[i].date}, Slot: ${dates[i].slot}, WashType: ${dates[i].washTypeId}',
        );
      }
      DPrint.log(
        '📷 Car Photo: ${carPhoto != null ? carPhoto!.path : "No photo"}',
      );
      DPrint.log('📤 ============================================');

      // Make API call
      final result = await _repository.createBooking(request);

      result.fold(
        (failure) {
          setError(failure.message);
          DPrint.log('❌ Create booking failed: ${failure.message}');
          Get.snackbar(
            'Booking Failed',
            failure.message,
            snackPosition: SnackPosition.BOTTOM,
          );
          setLoading(false);
        },
        (success) {
          _bookingResponse.value = success.data;
          DPrint.log('✅ Booking created successfully: ${success.data.id}');
          Get.snackbar(
            'Success',
            'Booking created successfully!',
            snackPosition: SnackPosition.BOTTOM,
          );
          setLoading(false);
        },
      );
    } catch (e) {
      setError('Unexpected error: $e');
      DPrint.log('❌ Create booking error: $e');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
      );
      setLoading(false);
    }
  }

  /// Clear all booking data
  void clearBookingData() {
    subscriptionType = null;
    userId = null;
    amount = null;
    vehicleId = null;
    vehicleType = null;
    locationAddress = null;
    locationLat = null;
    locationLng = null;
    carPhoto = null;
    licensePlate = null;
    scheduledDates = null;
    _bookingResponse.value = null;
    setError('');
  }
}
