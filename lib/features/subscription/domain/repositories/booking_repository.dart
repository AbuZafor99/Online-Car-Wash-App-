import '../../../../core/network/network_result.dart';
import '../../data/models/booking_response_model.dart';
import '../../data/models/booking_request_model.dart';

abstract class BookingRepository {
  NetworkResult<BookingResponseModel> createBooking(
    BookingRequestModel request,
  );
}
