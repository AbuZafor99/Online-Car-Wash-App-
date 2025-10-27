import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/core/theme/app_buttoms.dart';
import 'package:get/route_manager.dart';

import '../../../../core/theme/app_colors.dart';
import 'onboarding_screen_2.dart';

class OnbordingScreen1 extends StatelessWidget {
  const OnbordingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryWhite),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () {
                // Navigate to the next onboarding screen
              },
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Image.asset(
            'assets/icons/onbording_first.png',
            width: double.infinity,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Text(
            'Book a wash in seconds',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Schedule a car wash at your doorstep with just a few taps',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff4B5563),
              ),
            ),
          ),
          Spacer(),
          PrimaryButton(
            onPressed: () {
              //Todo: Navigate to the next onboarding screen
              Get.to(
                () => const OnboardingScreen2(),
                transition: Transition.rightToLeft,
              );
            },
            text: "Next",
            width: MediaQuery.of(context).size.width / 3,
            height: 60,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
