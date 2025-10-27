import '../../../../core/network/network_result.dart';
import '../../data/models/schedule_slot_model.dart';

abstract class ScheduleRepository {
  NetworkResult<List<ScheduleSlotModel>> getScheduleSlots();
  NetworkResult<ScheduleSlotModel> getSlotsByDate(DateTime date);
}
