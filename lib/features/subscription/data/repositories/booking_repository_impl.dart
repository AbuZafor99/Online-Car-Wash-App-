import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../../../core/utils/debug_print.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_request_model.dart';
import '../models/booking_response_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final ApiClient _apiClient;

  BookingRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<BookingResponseModel> createBooking(
    BookingRequestModel request,
  ) async {
    final result = await _apiClient.postFormData<BookingResponseModel>(
      '${ApiConstants.baseUrl}/booking',
      formData: _buildFormData(request),
      fromJsonT: (json) => BookingResponseModel.fromJson(json),
    );

    // Log after API call
    result.fold(
      (failure) => DPrint.log('❌ BOOKING API FAILED: ${failure.message}'),
      (success) =>
          DPrint.log('✅ BOOKING API SUCCESS: ${success.data.toJson()}'),
    );

    return result;
  }

  FormData _buildFormData(BookingRequestModel request) {
    final formData = FormData();

    // Add text fields
    formData.fields.add(MapEntry('user', request.userId));
    formData.fields.add(MapEntry('bookingType', request.bookingType));
    formData.fields.add(MapEntry('licensePlate', request.licensePlate));
    formData.fields.add(MapEntry('vehicle', request.vehicleId));

    // Add location as JSON string
    final locationJson = jsonEncode(request.location.toJson());
    formData.fields.add(MapEntry('location', locationJson));

    // Add dates as JSON string array
    final datesJson = jsonEncode(request.dates.map((d) => d.toJson()).toList());
    formData.fields.add(MapEntry('dates', datesJson));

    // Add car photo with field name 'car' (as per backend API)
    String? carPhotoPath;
    if (request.carPhoto != null) {
      final fileName = request.carPhoto!.path.split('/').last;
      formData.files.add(
        MapEntry(
          'car', // Changed from 'car_photo' to 'car'
          MultipartFile.fromFileSync(
            request.carPhoto!.path,
            filename: fileName,
          ),
        ),
      );
      carPhotoPath = request.carPhoto!.path;
    }

    // Single comprehensive log before API call
    DPrint.log(
      '📤 BOOKING API CALL - Form Data:\n'
      '   User: ${request.userId}\n'
      '   Booking Type: ${request.bookingType}\n'
      '   License Plate: ${request.licensePlate}\n'
      '   Vehicle: ${request.vehicleId}\n'
      '   Location: $locationJson\n'
      '   Dates: $datesJson\n'
      '   Car Photo: ${carPhotoPath ?? "Not provided"}',
    );

    return formData;
  }
}
