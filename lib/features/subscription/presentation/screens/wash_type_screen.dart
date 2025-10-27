import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/custom_app_bar.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/vehicle_photo_screen.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/wash_type_card.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import 'select_location_screen.dart';

class WashTypeScreen extends StatefulWidget {
  final String washType;

  const WashTypeScreen({super.key, this.washType = 'Monthly Subscription'});

  @override
  State<WashTypeScreen> createState() => _WashTypeScreenState();
}

class _WashTypeScreenState extends State<WashTypeScreen> {
  int? _selectedIndex;
  bool _isLoading = false;
  List<dynamic> _services = [];

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final api = ApiClient();
      final endpoint = '${ApiConstants.baseUrl}/service';
      // Use the widget.washType to request either Monthly Subscription or One-time Wash
      final result = await api.get(
        endpoint,
        queryParameters: {'washType': widget.washType, 'limit': '30'},
        fromJsonT: (json) => json,
      );

      result.fold(
        (failure) {
          // on failure, keep services empty and show a snackbar
          Get.snackbar('Error', 'Failed to load services: ${failure.message}');
        },
        (success) {
          final data = success.data;

          // The API may return different shapes for Monthly vs One-time.
          // Monthly endpoint (washType=Monthly Subscription) expected to return a list
          // or { services: [...] }. One-time endpoint returns { services: [...] } per sample.
          if (data is List) {
            _services = data.cast<dynamic>();
          } else if (data is Map) {
            // if response has 'services' key, use it; otherwise try to detect keys matching one-time model
            if (data['services'] != null && data['services'] is List) {
              _services = (data['services'] as List).cast<dynamic>();
            } else if (data['services'] == null &&
                data.containsKey('service') &&
                data['service'] is List) {
              _services = (data['service'] as List).cast<dynamic>();
            } else {
              // As a fallback, try to extract array-like entries from the map values
              _services = [];
            }
          } else {
            _services = [];
          }
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load services: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: CustomAppBar(title: "Select Wash Type")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Choose your preferred washing method',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _services.isEmpty
                ? Column(
                    children: [
                      // Fallback static cards if API returned nothing
                      WashTypeCard(
                        washType: 'Dry Wash',
                        washImage: 'assets/icons/Frame.png',
                        description: 'Eco-friendly wash without using water',
                        tag: 'Eco-friendly',
                        tagColor: const Color(0xff039A06),
                        tagBackgroundColor: const Color(0xffCCE0F5),
                        iconBackgroundColor: Colors.green.withAlpha(77),
                        isSelected: _selectedIndex == 0,
                        onTap: () => setState(() => _selectedIndex = 0),
                      ),
                      const SizedBox(height: 16),
                      WashTypeCard(
                        washType: 'Water Wash',
                        description: 'Water Wash',
                        iconBackgroundColor: Colors.blue.withAlpha(77),
                        isSelected: _selectedIndex == 1,
                        onTap: () => setState(() => _selectedIndex = 1),
                        showNote: true,
                        noteText:
                            'Note: Only available if your location permits water usage. We\'ll confirm this after you select your location.',
                        useIconInsteadOfImage: true,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 8),
                    itemBuilder: (context, index) {
                      final service = _services[index] as Map<String, dynamic>;

                      // Determine if service is Dry or Water based on name/type
                      // Support both Monthly and One-time models. Sample one-time model uses:
                      // serviceName, price, serviceDescription, serviceImage.url, washType
                      final name =
                          (service['serviceName'] ??
                                  service['name'] ??
                                  service['title'] ??
                                  '')
                              .toString();
                      final type =
                          (service['washType'] ?? service['type'] ?? '')
                              .toString();
                      final isDry =
                          name.toLowerCase().contains('dry') ||
                          type.toLowerCase().contains('dry');

                      final image =
                          (service['serviceImage'] != null &&
                              service['serviceImage'] is Map)
                          ? (service['serviceImage']['url'] ??
                                'assets/icons/Frame.png')
                          : (service['icon'] ?? 'assets/icons/Frame.png');

                      final description =
                          (service['serviceDescription'] ??
                                  service['description'] ??
                                  service['details'])
                              ?.toString() ??
                          (isDry
                              ? 'Eco-friendly wash without using water'
                              : 'Water based wash');

                      // Determine whether to show price: only for One-time Wash type
                      final serviceWashType = type.isNotEmpty
                          ? type
                          : widget.washType;
                      final showPrice =
                          serviceWashType.toLowerCase().contains('one-time') ||
                          serviceWashType.toLowerCase().contains('one time');
                      final priceString = showPrice
                          ? service['price']?.toString()
                          : null;

                      return WashTypeCard(
                        // Use the serviceName returned from API when available
                        washType: name.isNotEmpty
                            ? name
                            : (isDry ? 'Dry Wash' : 'Water Wash'),
                        washImage: image,
                        description: description,
                        tag: service['tag'],
                        tagColor: service['tagColor'] != null
                            ? Color(int.parse(service['tagColor'].toString()))
                            : null,
                        tagBackgroundColor:
                            service['tagBackgroundColor'] != null
                            ? Color(
                                int.parse(
                                  service['tagBackgroundColor'].toString(),
                                ),
                              )
                            : null,
                        iconBackgroundColor: isDry
                            ? Colors.green.withAlpha(77)
                            : Colors.blue.withAlpha(77),
                        isSelected: _selectedIndex == index,
                        onTap: () => setState(() => _selectedIndex = index),
                        showNote: service['note'] != null,
                        noteText: service['note']?.toString(),
                        price: priceString,
                        useIconInsteadOfImage:
                            image == 'assets/icons/Frame.png',
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: _services.length,
                  ),
          ),
          PrimaryButton(
            onPressed: () {
              if (_selectedIndex != null) {
                // Navigate to next screen with washType
                Get.to(
                  () => GoogleMapsTestScreen(washType: widget.washType),
                  transition: Transition.rightToLeft,
                );
              }
            },
            text: 'Continue',
          ),
          const SizedBox(height: 40),
        ],
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }
}
