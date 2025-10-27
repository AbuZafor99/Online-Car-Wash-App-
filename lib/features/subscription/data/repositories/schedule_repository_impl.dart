import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../models/schedule_slot_model.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final ApiClient _apiClient;

  ScheduleRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;
  @override
  NetworkResult<List<ScheduleSlotModel>> getScheduleSlots() {
    return _apiClient.get<List<ScheduleSlotModel>>(
      ApiConstants.schedule.getScheduleSlots,
      fromJsonT: (json) {
        // Handle different API response structures
        if (json is List) {
          return json
              .map(
                (item) =>
                    ScheduleSlotModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        } else if (json is Map<String, dynamic>) {
          // If single object returned, wrap in list
          return [ScheduleSlotModel.fromJson(json)];
        } else {
          // Return empty list if no valid data
          return <ScheduleSlotModel>[];
        }
      },
    );
  }

  @override
  NetworkResult<ScheduleSlotModel> getSlotsByDate(DateTime date) {
    // Format date as YYYY/MM/DD as required by the API
    final formattedDate =
        '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';

    return _apiClient.get<ScheduleSlotModel>(
      ApiConstants.schedule.getSlotsByDate,
      queryParameters: {'date': formattedDate},
      fromJsonT: (json) {
        // Handle different API response structures
        if (json is Map<String, dynamic>) {
          return ScheduleSlotModel.fromJson(json);
        } else if (json is List && json.isNotEmpty) {
          // If API returns an array, take the first item
          return ScheduleSlotModel.fromJson(json.first as Map<String, dynamic>);
        } else {
          // Return a fallback if no valid data
          throw Exception('Invalid schedule data format');
        }
      },
    );
  }
}
