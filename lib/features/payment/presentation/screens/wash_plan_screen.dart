import 'package:flutter/material.dart';
import 'package:flutter_youssefkleeno/core/common/widgets/app_scaffold.dart';

import '../../../../core/theme/app_colors.dart';

class WashPlanScreen extends StatelessWidget {
  const WashPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Your 4-Wash Plan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF03090D),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 52),
          Card(
            child: Container(
              height: MediaQuery.of(context).size.height / 4.08,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Car Wash Schedule',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 24,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 11,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/icons/edit.png',
                                height: 12,
                                width: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildWashTime(),
                  const SizedBox(height: 16),
                  _buildWashTime(),
                  const SizedBox(height: 16),
                  _buildWashTime(),
                  const SizedBox(height: 16),
                  _buildWashTime(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWashTime() {
    return Row(
      children: [
        Text(
          'Wash # 1:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        Text(
          '02/06/2025, ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          '08:00 ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        Text(
          'AM',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
