import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomFlotingActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  const CustomFlotingActionButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Color(0xff4291AF), width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.17),
                blurRadius: 13,
                spreadRadius: -3,
                offset: const Offset(-1, 40),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(
              'assets/icons/flotting_icon.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
