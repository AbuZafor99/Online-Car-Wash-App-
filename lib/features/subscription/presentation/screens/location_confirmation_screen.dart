import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/vehicle_photo_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import '../controllers/booking_controller.dart';
import '../controllers/location_controller.dart';

class LocationConfirmationScreen extends StatefulWidget {
  final String address;
  final double latitude;
  final double longitude;
  final String washType;

  const LocationConfirmationScreen({
    super.key,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.washType = 'Monthly Subscription',
  });

  @override
  State<LocationConfirmationScreen> createState() =>
      _LocationConfirmationScreenState();
}

class _LocationConfirmationScreenState
    extends State<LocationConfirmationScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _setLocationMarker();
  }

  void _setLocationMarker() {
    markers = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: LatLng(widget.latitude, widget.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: 'Selected Location',
          snippet: widget.address,
        ),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Center the map on the selected location
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(widget.latitude, widget.longitude),
        15.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Custom App Bar
          Container(
            // padding: EdgeInsets.only(
            //   top: MediaQuery.of(context).padding.top + 10,
            //   left: 16,
            //   right: 16,
            //   bottom: 10,
            // ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Your Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Location Address Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Google Map
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.latitude, widget.longitude),
                    zoom: 15.0,
                  ),
                  markers: markers,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                  rotateGesturesEnabled: true,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                ),
              ),
            ),
          ),

          // Current Location Button (Floating style)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
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

          // Bottom Action Buttons
          Container(
            // padding: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Back Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    final LocationController controller = Get.find<LocationController>();

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Get current location
      await controller.useCurrentLocation();

      // Dismiss loading
      Get.back();

      // Navigate back with current location data
      if (controller.selectedAddress.value.isNotEmpty) {
        Get.back(
          result: {
            'address': controller.selectedAddress.value,
            'latitude': controller.currentPosition.value.latitude,
            'longitude': controller.currentPosition.value.longitude,
          },
        );
      }
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

  void _confirmLocation() {
    // Store location data in BookingController
    final bookingController = Get.find<BookingController>();
    bookingController.locationAddress = widget.address;
    bookingController.locationLat = widget.latitude;
    bookingController.locationLng = widget.longitude;

    // Navigate to vehicle photo screen
    Get.to(() => VehiclePhotoScreen(washType: widget.washType));
  }
}
