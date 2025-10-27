import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _slideAnim;
  late final SplashController _controller;

  @override
  void initState() {
    super.initState();
    // Register the controller so it can handle navigation
    _controller = Get.put(SplashController());

    // Timings (ms)
    const inMs = 900; // enter from left
    const pauseMs = 500; // stay in center
    const outMs = 900; // exit to right

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: inMs + pauseMs + outMs),
    );

    // Sequence: left -> center, hold, center -> right
    _slideAnim = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(-1.5, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: inMs.toDouble(),
      ),
      TweenSequenceItem(
        tween: ConstantTween<Offset>(Offset.zero),
        weight: pauseMs.toDouble(),
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(1.5, 0),
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: outMs.toDouble(),
      ),
    ]).animate(_animController);

    // Start the sequence immediately: enter, pause 0.5s, exit
    _animController.forward().whenComplete(() {
      _controller.navigateToOnboarding();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use SlideTransition to move the logo to the right
            SlideTransition(
              position: _slideAnim,
              child: Image.asset(
                'assets/icons/logo.png',
                width: 246,
                height: 134,
              ),
            ),
            const SizedBox(height: 27),
            Text(
              'Wash smarter, not harder.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
