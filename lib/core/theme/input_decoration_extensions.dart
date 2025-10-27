import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';

import 'app_colors.dart';

extension InputDecorationExtensions on BuildContext {
  InputDecoration get primaryInputDecoration => InputDecoration(
    filled: true,
    suffixIconColor: AppColors.textFieldLightGrey,
    fillColor: AppColors.primaryWhite,
    contentPadding: AppSizes.paddingMd.all,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.size),
      borderSide: BorderSide(color: AppColors.textFieldLightGrey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.size),
      borderSide: BorderSide(color: AppColors.textFieldLightGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.size),
      borderSide: BorderSide(color: AppColors.textBlack, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.size),
      borderSide: const BorderSide(
        color: AppColors.deleteButtonBackground,
        width: 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSizes.paddingSm.size),
      borderSide: const BorderSide(
        color: AppColors.deleteButtonBackground,
        width: 1,
      ),
    ),
    hintStyle: TextStyle(
      color: AppColors.textFieldLightGrey,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelStyle: TextStyle(
      color: AppColors.textBlack,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    errorStyle: const TextStyle(
      color: AppColors.deleteButtonBackground,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  );
}

//
