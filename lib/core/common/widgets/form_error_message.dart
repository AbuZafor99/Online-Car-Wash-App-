import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class FormErrorMessage extends StatelessWidget {
  final String message;

  const FormErrorMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.deleteButtonBackground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
