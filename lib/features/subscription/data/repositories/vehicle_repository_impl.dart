import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final ApiClient _apiClient;

  VehicleRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  NetworkResult<VehicleResponse> getVehicles(String washType) {
    return _apiClient.get<VehicleResponse>(
      ApiConstants.vehicle.getVehicles,
      queryParameters: {'washType': washType},
      fromJsonT: (json) => VehicleResponse.fromJson(json),
    );
  }
}
