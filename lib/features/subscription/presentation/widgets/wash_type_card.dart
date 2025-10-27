import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class WashTypeCard extends StatelessWidget {
  final String? washType;
  final String? washImage;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? description;
  final String? tag;
  final Color? tagColor;
  final Color? tagBackgroundColor;
  final Color? iconBackgroundColor;
  final bool showNote;
  final String? noteText;
  final String? price;
  final bool useIconInsteadOfImage;

  const WashTypeCard({
    super.key,
    this.washType,
    this.washImage,
    this.isSelected = false,
    this.onTap,
    this.description,
    this.tag,
    this.tagColor,
    this.tagBackgroundColor,
    this.iconBackgroundColor,
    this.showNote = false,
    this.noteText,
    this.useIconInsteadOfImage = false,
    this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F1F5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : const Color(0xffE6E6E6),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? Colors.green.withAlpha(77),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: useIconInsteadOfImage
                          ? Icon(Icons.water_drop, size: 24, color: Colors.blue)
                          : (washImage != null &&
                                    washImage!.toLowerCase().contains('http')
                                ? Image.network(
                                    washImage!,
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                          Icons.image_not_supported,
                                          size: 24,
                                          color: Colors.grey,
                                        ),
                                  )
                                : Image.asset(
                                    washImage ?? "assets/icons/Frame.png",
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.contain,
                                  )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    washType ?? 'Dry Wash',
                    style: TextStyle(
                      color: AppColors.textBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (price != null)
                    Text(
                      price!,
                      style: TextStyle(
                        color: AppColors.textBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description ?? 'Eco-friendly wash without using water',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (tag != null) ...[
                const SizedBox(height: 8),
                IntrinsicWidth(
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: tagBackgroundColor ?? const Color(0xffCCE0F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        tag!,
                        style: TextStyle(
                          color: tagColor ?? const Color(0xff039A06),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              if (showNote && noteText != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F1CD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Note: $noteText!",
                    style: const TextStyle(
                      color: Color(0xFF8B4513),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
