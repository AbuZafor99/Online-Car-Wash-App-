import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/debug_print.dart';
import '../../../../core/common/constants/google_maps_api_key.dart';

class LocationController extends BaseController {
  LocationController() {
    _initializeLocation();
    _loadCustomMarkerIcons();
  }

  // Google Map Controller
  GoogleMapController? mapController;

  // Observable variables
  final RxString selectedAddress = ''.obs;
  final RxString searchQuery = ''.obs;
  final Rx<LatLng> currentPosition = const LatLng(37.7749, -122.4194).obs;
  final Rx<LatLng> selectedPosition = const LatLng(37.7749, -122.4194).obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  final RxBool isLoadingLocation = false.obs;
  final RxBool hasLocationPermission = false.obs;
  final RxList<Map<String, dynamic>> searchSuggestions =
      <Map<String, dynamic>>[].obs;

  // Custom marker icons
  BitmapDescriptor? defaultMarkerIcon;
  BitmapDescriptor? selectedMarkerIcon;

  // Text controllers
  final TextEditingController searchController = TextEditingController();

  // Search debounce timer
  Timer? _searchDebounce;

  // Camera position
  CameraPosition get initialCameraPosition =>
      CameraPosition(target: currentPosition.value, zoom: 14.0);

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  @override
  void onClose() {
    searchController.dispose();
    mapController?.dispose();
    super.onClose();
  }

  // Initialize location services
  Future<void> _initializeLocation() async {
    isLoadingLocation.value = true;

    try {
      // Check and request location permissions
      await _checkLocationPermission();

      if (hasLocationPermission.value) {
        // Get current location
        await _getCurrentLocation();
      }
    } catch (e) {
      setError('Failed to initialize location: $e');
      DPrint.log('❌ Failed to initialize location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Load custom marker icons
  Future<void> _loadCustomMarkerIcons() async {
    try {
      defaultMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/icons/location_pin.png',
      );

      selectedMarkerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(56, 56)),
        'assets/icons/location_pin_selected.png',
      );
      DPrint.log('✅ Custom marker icons loaded successfully');
    } catch (e) {
      DPrint.log('⚠️ Failed to load custom marker icons: $e');
      DPrint.log('Using default markers instead');
      // Keep defaultMarkerIcon and selectedMarkerIcon as null to use default markers
    }
  }

  // Check location permission
  Future<void> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        // Show message to user about manually enabling permissions
        Get.snackbar(
          'Permissions Required',
          'Please enable location permissions in app settings',
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800,
          duration: const Duration(seconds: 5),
        );
        hasLocationPermission.value = false;
        return;
      }

      hasLocationPermission.value =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      hasLocationPermission.value = false;
      setError('Permission error: $e');
    }
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      if (!hasLocationPermission.value) {
        await _checkLocationPermission();
        if (!hasLocationPermission.value) return;
      }

      isLoadingLocation.value = true;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      LatLng newPosition = LatLng(position.latitude, position.longitude);
      currentPosition.value = newPosition;
      selectedPosition.value = newPosition;

      // Move camera to current location
      if (mapController != null) {
        await mapController!.animateCamera(CameraUpdate.newLatLng(newPosition));
      }

      // Update marker
      await _updateMarker(newPosition);

      // Get address from coordinates
      await _getAddressFromLatLng(newPosition);
    } catch (e) {
      setError('Failed to get current location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Update marker on map
  Future<void> _updateMarker(LatLng position) async {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          selectedPosition.value = newPosition;
          _getAddressFromLatLng(newPosition);
        },
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
  }

  // Get address from coordinates
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        selectedAddress.value = _formatAddress(place);
      }
    } catch (e) {
      setError('Failed to get address: $e');
    }
  }

  // Format address from placemark
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return addressParts.join(', ');
  }

  // Handle map tap
  void onMapTap(LatLng position) {
    selectedPosition.value = position;
    _updateMarker(position);
    _getAddressFromLatLng(position);
  }

  // Handle map creation
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    DPrint.log('🗺️ Google Map created successfully');

    // Move to current location if available
    if (currentPosition.value.latitude != 37.7749 ||
        currentPosition.value.longitude != -122.4194) {
      controller.animateCamera(CameraUpdate.newLatLng(currentPosition.value));
    }
  }

  // Search for locations using Google Places API
  Future<void> searchLocation(String query) async {
    if (query.isEmpty) {
      searchSuggestions.clear();
      return;
    }

    // Cancel previous search
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce?.cancel();
    }

    // Debounce search requests
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      await _performLocationSearch(query);
    });
  }

  // Perform the actual location search
  Future<void> _performLocationSearch(String query) async {
    try {
      searchQuery.value = query;
      DPrint.log('🔍 Searching for location: $query');

      // Use the API key from constants
      const String apiKey = GoogleMapsApiKey.apiKey;

      // Use Google Places Text Search API for better results
      final url =
          'https://maps.googleapis.com/maps/api/place/textsearch/json?'
          'query=${Uri.encodeComponent(query)}&'
          'key=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'] != null) {
          final results = data['results'] as List;

          // Update search suggestions
          searchSuggestions.value = results.take(5).map((place) {
            return {
              'place_id': place['place_id'] ?? '',
              'name': place['name'] ?? 'Unknown Location',
              'address': place['formatted_address'] ?? 'No address available',
              'lat': place['geometry']?['location']?['lat']?.toDouble() ?? 0.0,
              'lng': place['geometry']?['location']?['lng']?.toDouble() ?? 0.0,
            };
          }).toList();

          // If we have results, select the first one
          if (results.isNotEmpty) {
            final firstResult = results[0];
            final lat =
                firstResult['geometry']?['location']?['lat']?.toDouble() ?? 0.0;
            final lng =
                firstResult['geometry']?['location']?['lng']?.toDouble() ?? 0.0;

            if (lat != 0.0 && lng != 0.0) {
              final newPosition = LatLng(lat, lng);
              selectedPosition.value = newPosition;
              selectedAddress.value =
                  firstResult['formatted_address'] ?? firstResult['name'] ?? '';

              await _updateMarker(newPosition);

              // Move camera to searched location
              if (mapController != null) {
                await mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(newPosition, 16.0),
                );
              }

              DPrint.log('✅ Location found: ${selectedAddress.value}');
            }
          }
        } else {
          DPrint.log('⚠️ Google Places API returned: ${data['status']}');
          // Fallback to geocoding
          await _fallbackGeocoding(query);
        }
      } else {
        DPrint.log('❌ Places API request failed: ${response.statusCode}');
        // Fallback to geocoding
        await _fallbackGeocoding(query);
      }
    } catch (e) {
      DPrint.log('❌ Location search error: $e');
      // Fallback to geocoding
      await _fallbackGeocoding(query);
    }
  }

  // Fallback to basic geocoding if Places API fails
  Future<void> _fallbackGeocoding(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newPosition = LatLng(location.latitude, location.longitude);

        selectedPosition.value = newPosition;
        await _updateMarker(newPosition);
        await _getAddressFromLatLng(newPosition);

        // Move camera to searched location
        if (mapController != null) {
          await mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, 16.0),
          );
        }

        DPrint.log('✅ Fallback geocoding successful');
      } else {
        setError('Location not found: $query');
      }
    } catch (e) {
      setError('Location not found: $query');
      DPrint.log('❌ Fallback geocoding failed: $e');
    }
  }

  // Select a location from search suggestions
  void selectSearchSuggestion(Map<String, dynamic> suggestion) {
    final lat = suggestion['lat'] as double;
    final lng = suggestion['lng'] as double;
    final address = suggestion['address'] as String;

    if (lat != 0.0 && lng != 0.0) {
      final newPosition = LatLng(lat, lng);
      selectedPosition.value = newPosition;
      selectedAddress.value = address;

      _updateMarker(newPosition);

      // Move camera to selected location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(newPosition, 16.0),
        );
      }

      // Clear search suggestions
      searchSuggestions.clear();
      searchController.clear();

      DPrint.log('✅ Selected location: $address');
    }
  }

  // Use current location button
  Future<void> useCurrentLocation() async {
    await _getCurrentLocation();
  }

  // Confirm location selection
  void confirmLocation() {
    if (selectedAddress.value.isNotEmpty) {
      // Return to previous screen with selected location
      Get.back(
        result: {
          'address': selectedAddress.value,
          'latitude': selectedPosition.value.latitude,
          'longitude': selectedPosition.value.longitude,
        },
      );
    } else {
      Get.snackbar(
        'Location Required',
        'Please select a location first',
        backgroundColor: Colors.orange.shade50,
        colorText: Colors.orange.shade800,
        icon: Icon(Icons.warning, color: Colors.orange.shade600),
      );
    }
  }

  // Add some predefined locations for quick access
  List<Map<String, dynamic>> get quickLocations => [
    {
      'name': '2972 Westheimer Rd. Santa Ana, Illinois 85486',
      'latLng': const LatLng(40.116386, -88.243385),
    },
    {
      'name': '1901 Thornridge Cir. Shiloh, Hawaii 81063',
      'latLng': const LatLng(21.289373, -157.917480),
    },
  ];

  // Select quick location
  void selectQuickLocation(Map<String, dynamic> location) {
    LatLng position = location['latLng'];
    selectedPosition.value = position;
    selectedAddress.value = location['name'];

    _updateMarker(position);

    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngZoom(position, 16.0));
    }

    DPrint.log('✅ Quick location selected: ${location['name']}');
  }

  // Clear search and reset to initial state
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchSuggestions.clear();
    selectedAddress.value = '';
    markers.clear();

    // Reset to current location if available
    if (currentPosition.value.latitude != 37.7749 ||
        currentPosition.value.longitude != -122.4194) {
      selectedPosition.value = currentPosition.value;
      _updateMarker(currentPosition.value);
      _getAddressFromLatLng(currentPosition.value);
    }

    DPrint.log('🔄 Search cleared, reset to current location');
  }
}
