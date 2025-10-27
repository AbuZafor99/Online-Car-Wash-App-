import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:karlfive/features/Home/presentation/screen/home_screen.dart';
// import 'package:karlfive/features/home_static_screens/presantation/screen/aboutus_screen.dart';
// import 'package:karlfive/features/profile_dasboard/presentation/screens/personal_iformation_screen.dart';
import '../../../core/bottomNavbar/widgets/custom_bottom_navbar.dart';
// import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> screens = const [
    // HomeScreen(),
    Center(child: Text("Chat Screen")),
    Center(child: Text("Notifications")),

    // ProfileDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[navController.currentIndex.value]),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}
