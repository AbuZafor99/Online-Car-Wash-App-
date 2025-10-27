import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class VehicleSelectCard extends StatelessWidget {
  final String? vehicleType;
  final String? vehicleImage;
  final bool isSelected;
  final VoidCallback? onTap;

  const VehicleSelectCard({
    super.key,
    this.vehicleType,
    this.vehicleImage,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.selectedChipBackground
              : Color(0xffE6E6E6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xffE6E6E6), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
          child: Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: const Color(0xffCCE0F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      vehicleImage != null && vehicleImage!.startsWith('http')
                      ? Image.network(
                          vehicleImage!,
                          fit: BoxFit.contain,
                          height: 24,
                          width: 24,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.directions_car,
                              size: 24,
                              color: AppColors.primaryBlue,
                            );
                          },
                        )
                      : Image.asset(
                          vehicleImage ?? 'assets/icons/bike.png',
                          fit: BoxFit.contain,
                          height: 24,
                          width: 24,
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                vehicleType ?? 'Car',
                style: TextStyle(
                  color: AppColors.textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
