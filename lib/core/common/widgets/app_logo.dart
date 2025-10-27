import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final double width;
  final String images;

  const AppLogo({
    super.key,
    this.height = 120,
    this.width = 120,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      images,
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}
