import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.textBlack,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
