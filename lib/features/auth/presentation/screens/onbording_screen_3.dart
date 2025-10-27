import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import 'package:flutter_youssefkleeno/features/home/presentation/screens/home.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_buttoms.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
            'assets/icons/onbording_three.png',
            width: double.infinity,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
          Text(
            'Subscription or one-time',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textBlack,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: Text(
              'Choose what works for you, save with a subscription',
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
              Get.to(() => Home(), transition: Transition.rightToLeft);
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
