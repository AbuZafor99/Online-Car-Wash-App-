import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:flutter_youssefkleeno/core/theme/app_colors.dart';
import 'package:flutter_youssefkleeno/features/complete_profile/presentation/screens/complete_profile.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/monthly_subscription_plan_screen.dart';
import 'package:flutter_youssefkleeno/features/subscription/presentation/screens/vehicle_screen.dart';
import 'package:flutter_youssefkleeno/features/user_profile/presantation/screens/profile_screen.dart';
// api client and constants are used by repository/controller
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../data/models/home_service_model.dart';
import '../widgets/wash_type_card_widget.dart';
// provider not required; controller is listened to directly

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.loadMonthlyServices();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image(
                      image: AssetImage('assets/icons/logo.png'),
                      width: 37,
                      height: 30,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Hi Joy, ready for a wash',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Get.to(ProfileScreen()),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.primaryBlue,
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          "assets/images/profileimage.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 27),
                Container(
                  height: 160,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_booking.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 21),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sparkling Clean Cars,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Delivered To You',
                        style: TextStyle(
                          color: Color(0xFF499FC0),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => MonthlySubscriptionPlanScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(120, 28),
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.all(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Booking Now',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward_outlined, size: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    _buildWashCard(
                      'assets/icons/calender_circle.png',
                      'Subscription Wash',
                      onTap: () => Get.to(
                        VehicleScreen(washType: 'Monthly Subscription'),
                      ),
                    ),
                    Spacer(),
                    _buildWashCard(
                      'assets/icons/car_circle.png',
                      'One-time wash',
                      onTap: () {
                        print('🏠 Home: One-time wash card tapped');
                        Get.to(const VehicleScreen(washType: 'One-time Wash'));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    PrimaryButton(
                      onPressed: () {
                        Get.to(CompleteProfile());
                      },
                      text: 'Refer & Earn',
                      width: 218,
                      borderRadius: 9999,
                    ),
                    Spacer(),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                      ),
                      child: Icon(Icons.copy, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 49),
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/home_star.png'),
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Our Wash Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // render monthly services (first 3) using controller data
                _controller.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (() {
                        final services = _controller.services.isNotEmpty
                            ? _controller.services.take(3).toList()
                            : _getDefaultWashTypes()
                                  .map((m) => HomeServiceModel.fromMap(m))
                                  .toList();
                        return Column(
                          children: [
                            for (int i = 0; i < services.length; i++) ...[
                              WashTypeCardWidget(model: services[i]),
                              if (i < services.length - 1)
                                const SizedBox(height: 16),
                            ],
                          ],
                        );
                      })(),
                const SizedBox(height: 64),
                Row(
                  children: [
                    Image(
                      image: AssetImage('assets/icons/done.png'),
                      height: 24,
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How It Works',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _workCard(
                  'assets/icons/car_square.png',
                  'Choose Your Service',
                  'Select between one-time wash or monthly subscription',
                ),
                const SizedBox(height: 15),
                _workCard(
                  'assets/icons/water_square.png',
                  'Select Vehicle & Wash Type',
                  'Choose your vehicle type and preferred wash method',
                ),
                const SizedBox(height: 15),
                _workCard(
                  'assets/icons/location_square.png',
                  'Set Location',
                  'Pin your location on the map or enter address manually',
                ),
                const SizedBox(height: 15),
                _workCard(
                  'assets/icons/calender_square.png',
                  'Schedule',
                  'Pick a convenient date and time for your car wash',
                ),
                const SizedBox(height: 15),
                _workCard(
                  'assets/icons/payment_square.png',
                  'Payment',
                  'Secure payment through our platform',
                ),
                const SizedBox(height: 15),
                _workCard(
                  'assets/icons/done_square.png',
                  'Confirmation',
                  'Receive confirmation and enjoy your clean car',
                ),
                const SizedBox(height: 48),
                Container(
                  height: 124,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_offer.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(89, 24),
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF0066CC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: EdgeInsets.all(6),
                        ),
                        child: Text(
                          'BEST VALUE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '20% OFF Your First Wash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Use code: FIRST20',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Container(
                    height: 95,
                    padding: EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage(
                                'assets/icons/satisfaction.png',
                              ),
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              '100%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Satisfaction',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/icons/done.png'),
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              'Verified Pros',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage('assets/icons/leaf.png'),
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              'Eco-Friendly',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      showFloatingActionButton: true,
      onFabTap: () {},
    );
  }

  Widget _workCard(String assetPath, String title, String description) {
    return Card(
      child: Container(
        height: 118,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image(image: AssetImage(assetPath), height: 28, width: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildWashCard(String iconPath, String title, {VoidCallback? onTap}) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 161,
          height: 96,
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage(iconPath), height: 40, width: 40),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // helper removed: logic now handled by controller and WashTypeCardWidget

  List<Map<String, dynamic>> _getDefaultWashTypes() {
    return [
      {
        'serviceName': 'Dry Wash',
        'serviceDescription': 'Eco-friendly wash without using water',
        'serviceImage': {'url': ''},
        'tag': 'Eco-friendly',
        'isDry': true,
      },
      {
        'serviceName': 'Water Wash',
        'serviceDescription': 'Water Wash',
        'serviceImage': {'url': ''},
        'tag': '',
        'isDry': false,
        'hasNote': true,
        'note':
            'Note: Only available if your location permits water usage. We\'ll confirm this after you select your location.',
      },
      {
        'serviceName': 'Steam Wash',
        'serviceDescription': 'Deep cleaning with steam technology',
        'serviceImage': {'url': ''},
        'tag': '',
        'isDry': false,
        'hasNote': true,
        'note': 'Note: One of the four wash options will include a Steam Wash.',
      },
    ];
  }

  // legacy helper removed; using WashTypeCardWidget and HomeServiceModel
}
