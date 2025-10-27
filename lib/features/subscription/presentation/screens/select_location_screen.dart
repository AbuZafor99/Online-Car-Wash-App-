import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/vehicle_photo_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/custom_app_bar.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../controllers/location_controller.dart';

class GoogleMapsTestScreen extends StatefulWidget {
  final String washType;

  const GoogleMapsTestScreen({
    super.key,
    this.washType = 'Monthly Subscription',
  });

  @override
  State<GoogleMapsTestScreen> createState() => _GoogleMapsTestScreenState();
}

class _GoogleMapsTestScreenState extends State<GoogleMapsTestScreen>
    with TickerProviderStateMixin {
  final LocationController controller = Get.put(LocationController());
  final TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool isExpanded = false;
  bool isLocationSelected = false;
  String selectedAddress = '';
  double selectedLatitude = 0.0;
  double selectedLongitude = 0.0;
  final double collapsedHeight = 80;
  final double expandedHeight = 500;
  final double confirmationHeight = 120;

  // Sample location history
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _toggleBottomSheet() {
    setState(() {
      isExpanded = !isExpanded;
    });

    if (isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: CustomAppBar(title: 'Google Maps'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Google Map
          Obx(() {
            if (controller.isLoadingLocation.value) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading location...'),
                  ],
                ),
              );
            }

            return GoogleMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: controller.initialCameraPosition,
              markers: controller.markers,
              onTap: controller.onMapTap,
              myLocationEnabled: controller.hasLocationPermission.value,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              compassEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              tiltGesturesEnabled: true,
              zoomGesturesEnabled: true,
              mapToolbarEnabled: false,
              indoorViewEnabled: true,
              trafficEnabled: false,
            );
          }),

          // Draggable Bottom Sheet
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: isLocationSelected
                ? _buildConfirmationBottomSheet()
                : _buildSearchBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBottomSheet() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentHeight =
            collapsedHeight +
            (expandedHeight - collapsedHeight) * _animation.value;

        return Container(
          height: currentHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle and collapsed content
              GestureDetector(
                onTap: _toggleBottomSheet,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      // Drag handle
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Title (always visible in collapsed state)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Enter your Location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search field and expanded content (only visible when expanded)
              if (_animation.value > 0)
                Expanded(
                  child: Opacity(
                    opacity: _animation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),

                          // Search Input Field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: searchController,
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
                                controller.searchLocation(value);
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Location History
                          Expanded(
                            child: ListView(
                              children: [
                                ...locationHistory.map(
                                  (location) => _buildLocationItem(
                                    icon: location['icon'],
                                    address: location['address'],
                                    onTap: () => _selectLocationFromHistory(
                                      location['address'],
                                    ),
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
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
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
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmationBottomSheet() {
    return Container(
      // height: confirmationHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Column(
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Selected location display
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                // Back Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: _goBackToSearch,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Confirm Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
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
      await controller.searchLocation(searchText);

      // Get back and dismiss loading
      Get.back();

      // If search was successful, show result on map and confirmation sheet
      if (controller.searchSuggestions.isNotEmpty) {
        final firstResult = controller.searchSuggestions.first;
        final lat = firstResult['latitude'] ?? 0.0;
        final lng = firstResult['longitude'] ?? 0.0;

        if (lat != 0.0 && lng != 0.0) {
          // Move map to location
          controller.mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0),
          );

          // Show confirmation bottom sheet
          _showLocationConfirmation(
            address: firstResult['description'] ?? searchText,
            latitude: lat,
            longitude: lng,
          );
        }
      } else {
        // If no search results, still show confirmation with search text
        _showLocationConfirmation(
          address: searchText,
          latitude: 37.7749, // Default coordinates
          longitude: -122.4194,
        );
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
    // Show confirmation bottom sheet with history address
    _showLocationConfirmation(
      address: address,
      latitude: 37.7749, // Default coordinates - should be geocoded in real app
      longitude: -122.4194,
    );
  }

  void _getCurrentLocation() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Use the location controller to get current location
      await controller.useCurrentLocation();

      // Dismiss loading
      Get.back();

      // Move map to current location and show confirmation
      controller.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(
            controller.currentPosition.value.latitude,
            controller.currentPosition.value.longitude,
          ),
          15.0,
        ),
      );

      // Show confirmation bottom sheet with current location
      _showLocationConfirmation(
        address: controller.selectedAddress.value.isNotEmpty
            ? controller.selectedAddress.value
            : 'Current Location',
        latitude: controller.currentPosition.value.latitude,
        longitude: controller.currentPosition.value.longitude,
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

  void _showLocationConfirmation({
    required String address,
    required double latitude,
    required double longitude,
  }) {
    setState(() {
      isLocationSelected = true;
      selectedAddress = address;
      selectedLatitude = latitude;
      selectedLongitude = longitude;

      // Collapse the search bottom sheet if it was expanded
      if (isExpanded) {
        isExpanded = false;
        _animationController.reverse();
      }
    });
  }

  void _goBackToSearch() {
    setState(() {
      isLocationSelected = false;
      selectedAddress = '';
      selectedLatitude = 0.0;
      selectedLongitude = 0.0;
    });
  }

  void _confirmLocation() {
    // Store location data in BookingController
    final bookingController = Get.find<BookingController>();

    // Use selectedAddress or fall back to controller's selected address
    final address = selectedAddress.isNotEmpty
        ? selectedAddress
        : controller.selectedAddress.value;
    final lat = selectedLatitude != 0.0
        ? selectedLatitude
        : controller.currentPosition.value.latitude;
    final lng = selectedLongitude != 0.0
        ? selectedLongitude
        : controller.currentPosition.value.longitude;

    bookingController.locationAddress = address;
    bookingController.locationLat = lat;
    bookingController.locationLng = lng;

    print('🗺️  Saved location to BookingController:');
    print('   Address: $address');
    print('   Lat: $lat');
    print('   Lng: $lng');

    // Navigate to vehicle photo screen
    Get.to(() => VehiclePhotoScreen(washType: widget.washType));
  }
}
