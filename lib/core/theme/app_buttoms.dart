import 'package:flutter/material.dart';

import 'app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double? height;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final Widget? child;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.isLoading = false,
    this.backgroundColor = AppColors.primaryBlue,
    this.textColor = AppColors.primaryWhite,
    this.borderRadius = 8.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Opacity(
          opacity: isLoading ? 0.6 : 1.0,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (text.toLowerCase() == "next") ...[
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: textColor),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? child;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final double borderRadius;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.child,
    this.backgroundColor = AppColors.primaryWhite,
    this.textColor = AppColors.textBlack,
    this.borderColor = AppColors.textBlue,
    this.width,
    this.height,
    this.isLoading = false,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Opacity(
          opacity: isLoading ? 0.6 : 1.0,
          child: Container(
            width: width ?? double.infinity,
            height: height ?? 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : (child ??
                      Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
          ),
        ),
      ),
    );
  }
}
