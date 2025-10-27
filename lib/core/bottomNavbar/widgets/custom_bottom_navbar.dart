import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:karlfive/features/home_static_screens/presantation/screen/aboutus_screen.dart';
// import '../../../features/company_pricing/presentation/screens/plan_pricing_screen.dart';
// import '../../../features/profile_dasboard/presentation/screens/profile_dashboard_screen.dart';
import '../controllers/bottom_nav_controller.dart';

class CustomBottomNavBar extends StatelessWidget {
  final BottomNavController navController = Get.find<BottomNavController>();

  CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomNavigationBar(
        currentIndex: navController.currentIndex.value,
        onTap: (index) {
          navController.changeIndex(index);

          // if (index == 0) {
          //   Get.to(() => const AboutUsScreen());
          // }
          //
          // if (index == 2) {
          //   Get.to(() => const PlanPricingScreen());
          // }
          //
          // if (index == 3) {
          //   Get.offAll(() => const ProfileDashboardScreen());
          // }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF4F6FF),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/nav_home.png",
              width: 24,
              height: 24,
              color: navController.currentIndex.value == 0
                  ? Colors.blue
                  : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/nav_chat.png",
              width: 24,
              height: 24,
              color: navController.currentIndex.value == 1
                  ? Colors.blue
                  : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/nav_noti.png",
              width: 24,
              height: 24,
              color: navController.currentIndex.value == 2
                  ? Colors.blue
                  : Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              "assets/icons/nav_profile.png",
              width: 24,
              height: 24,
              color: navController.currentIndex.value == 3
                  ? Colors.blue
                  : Colors.black,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
