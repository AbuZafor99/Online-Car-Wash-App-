import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import '../controllers/location_controller.dart';

class LocationSelectionWidget extends StatelessWidget {
  final String? currentAddress;
  final Function(Map<String, dynamic>) onLocationSelected;

  const LocationSelectionWidget({
    super.key,
    this.currentAddress,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(Icons.location_on, color: AppColors.primaryBlue),
        title: Text(
          currentAddress ?? 'Select Location',
          style: TextStyle(
            color: currentAddress != null ? Colors.black : Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        subtitle: currentAddress == null
            ? const Text(
                'Tell us where to provide the service',
                style: TextStyle(fontSize: 12),
              )
            : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showLocationBottomSheet(context),
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          LocationBottomSheet(onLocationSelected: onLocationSelected),
    );
  }
}

class LocationBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onLocationSelected;

  const LocationBottomSheet({super.key, required this.onLocationSelected});

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // Sample location history - you can make this dynamic from shared preferences
  final List<Map<String, dynamic>> locationHistory = [
    {
      'address': '2972 Westheimer Rd, Santa Ana, Illinois 85486',
      'icon': Icons.history,
    },
    {
      'address': '1901 Thornridge Cir, Shiloh, Hawaii 81063',
      'icon': Icons.history,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto focus on the search field when bottom sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Enter your Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Search Input Field
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: searchController,
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Enter a location',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _searchAndSelectLocation(value.trim());
                  }
                },
                onChanged: (value) {
                  // You can add real-time search suggestions here
                  locationController.searchLocation(value);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Location History
            ...locationHistory.map(
              (location) => _buildLocationItem(
                icon: location['icon'],
                address: location['address'],
                onTap: () => _selectLocationFromHistory(location['address']),
              ),
            ),

            const SizedBox(height: 30),

            // Current Location Button (Floating style)
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: _getCurrentLocation,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required IconData icon,
    required String address,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                address,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _searchAndSelectLocation(String searchText) async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Use the location controller to search for the location
      await locationController.searchLocation(searchText);

      // Get back and dismiss loading
      Get.back();

      // If search was successful, select the location
      if (locationController.searchSuggestions.isNotEmpty) {
        final firstResult = locationController.searchSuggestions.first;
        _selectLocation(
          address: firstResult['description'] ?? searchText,
          latitude: firstResult['latitude'] ?? 0.0,
          longitude: firstResult['longitude'] ?? 0.0,
        );
      } else {
        // If no results, still set the searched text as location
        _selectLocation(address: searchText, latitude: 0.0, longitude: 0.0);
      }
    } catch (e) {
      Get.back(); // Dismiss loading
      Get.snackbar(
        'Error',
        'Failed to search location: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _selectLocationFromHistory(String address) {
    // For history items, you might want to geocode the address to get coordinates
    _selectLocation(address: address, latitude: 0.0, longitude: 0.0);
  }

  void _getCurrentLocation() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Use the location controller to get current location
      await locationController.useCurrentLocation();

      // Dismiss loading
      Get.back();

      // Select the current location
      _selectLocation(
        address: locationController.selectedAddress.value.isNotEmpty
            ? locationController.selectedAddress.value
            : 'Current Location',
        latitude: locationController.currentPosition.value.latitude,
        longitude: locationController.currentPosition.value.longitude,
      );
    } catch (e) {
      Get.back(); // Dismiss loading
      Get.snackbar(
        'Error',
        'Failed to get current location: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _selectLocation({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    final locationData = {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };

    widget.onLocationSelected(locationData);
    Navigator.pop(context);
  }
}

// Example usage in a form or screen:
class ExampleUsageScreen extends StatelessWidget {
  const ExampleUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RxString selectedAddress = ''.obs;
    final RxDouble latitude = 0.0.obs;
    final RxDouble longitude = 0.0.obs;

    return Scaffold(
      appBar: AppBar(title: const Text('Service Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Other form fields...
            Obx(
              () => LocationSelectionWidget(
                currentAddress: selectedAddress.value.isEmpty
                    ? null
                    : selectedAddress.value,
                onLocationSelected: (location) {
                  selectedAddress.value = location['address'];
                  latitude.value = location['latitude'];
                  longitude.value = location['longitude'];

                  // Use the selected location data as needed
                  // You can process the location data here
                },
              ),
            ),

            const SizedBox(height: 20),

            // Continue button or other actions
            Obx(
              () => selectedAddress.value.isNotEmpty
                  ? PrimaryButton(
                      onPressed: () {
                        // Proceed with booking
                        Get.snackbar(
                          'Success',
                          'Location selected: ${selectedAddress.value}',
                        );
                      },
                      text: 'Continue',
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
