import 'package:flutter/material.dart';
import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyBookingsScreen extends StatelessWidget {
  const EmptyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          "My Bookings",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- Decorative Empty Card ---
              Card(
                elevation: 0,
                child: Container(
                  height: 480,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.transparent,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryWhite.withOpacity(0.1),
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/bg.png',
                            height: 470,
                            width: 470,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Your wash history is empty",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 400),
            ],
          ),
        ),
      ),
    );
  }
}
