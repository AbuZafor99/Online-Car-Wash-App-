import 'package:flutter/material.dart';

import '../../../../core/common/widgets/app_scaffold.dart';
import '../../../../core/theme/app_colors.dart';

class Confirmed extends StatefulWidget {
  const Confirmed({super.key});

  @override
  State<Confirmed> createState() => _ConfirmedState();
}

class _ConfirmedState extends State<Confirmed> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Your car wash has been successfully scheduled.',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 32),
            Card(
              child: Container(
                height: 571,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Booking ID',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'BK9520',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildWashTime(),
                    const SizedBox(height: 16),
                    _buildWashTime(),
                    const SizedBox(height: 16),
                    _buildWashTime(),
                    const SizedBox(height: 16),
                    _buildWashTime(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/home.png',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 28),
                        Text(
                          'Home: 123 Main St',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/hand_star.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Service',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 28),
                        Text(
                          'Water Wash',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFE8E8E8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Divider(color: Color(0xFF428FAD)),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Paid',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '\$29',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
    );
  }

  Widget _buildWashTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              'Wash # 1: 02/06/2025',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 28),
            Text(
              '8:00 AM-10:00 AM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFE8E8E8),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
