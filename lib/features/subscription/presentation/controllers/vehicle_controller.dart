import 'package:get/get.dart';
import 'package:flutx_core/flutx_core.dart';
import '../../../../core/base/base_controller.dart';
import '../../data/models/vehicle_model.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleController extends BaseController {
  final VehicleRepository _vehicleRepository;

  VehicleController(this._vehicleRepository);

  // Private observable variables
  final RxList<Vehicle> _vehicles = <Vehicle>[].obs;
  final RxInt _selectedIndex = (-1).obs;

  // Public getters
  List<Vehicle> get vehicles => _vehicles.toList();
  int get selectedIndex => _selectedIndex.value;
  RxString get error => errorMessage; // For backward compatibility
  bool get hasVehicles => _vehicles.isNotEmpty;
  bool get canContinue => _selectedIndex.value >= 0;
  Vehicle? get selectedVehicle =>
      _selectedIndex.value >= 0 && _selectedIndex.value < _vehicles.length
      ? _vehicles[_selectedIndex.value]
      : null;

  /// Fetch vehicles from API
  Future<void> fetchVehicles({String washType = 'Monthly Subscription'}) async {
    setLoading(true);
    setError('');

    final result = await _vehicleRepository.getVehicles(washType);

    result.fold(
      (failure) {
        setError(failure.message);
        DPrint.log('Get vehicles failed: ${failure.message}');
        _vehicles.clear();
        Get.snackbar(
          'Error',
          'Failed to load vehicles: ${failure.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
      (success) {
        _vehicles.value = success.data.vehicles;
        DPrint.log('Get vehicles success: ${_vehicles.length} vehicles loaded');

        if (_vehicles.isEmpty) {
          setError('No vehicles available for this service type.');
        }
        setLoading(false);
      },
    );
  }

  /// Select a vehicle by index
  void selectVehicle(int index) {
    if (index >= 0 && index < _vehicles.length) {
      _selectedIndex.value = index;
    }
  }

  /// Clear selection
  void clearSelection() {
    _selectedIndex.value = -1;
  }

  /// Retry fetching vehicles with the last used wash type
  void retry() {
    fetchVehicles();
  }

  /// Set and fetch vehicles for a specific wash type
  Future<void> setWashTypeAndFetch(String washType) async {
    await fetchVehicles(washType: washType);
  }

  @override
  void onClose() {
    _vehicles.clear();
    super.onClose();
  }
}
