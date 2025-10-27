import '../../../../core/network/network_result.dart';
import '../../data/models/vehicle_model.dart';

abstract class VehicleRepository {
  NetworkResult<VehicleResponse> getVehicles(String washType);
}
