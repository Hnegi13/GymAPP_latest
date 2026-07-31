import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {

  static const TextStyle heading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.title,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColors.subtitle,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.bold,
    color: AppColors.title,
  );
}