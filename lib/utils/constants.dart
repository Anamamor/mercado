import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color secondary = Color(0xFF8BC34A);
  static const Color accent = Color(0xFFCDDC39);
  static const Color background = Color(0xFFF1F8E9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE57373);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF2E7D32);
  static const Color textSecondary = Color(0xFF757575);
}

class AppConstants {
  static const String appName = 'AgriMarket';
  static const List<String> categories = [
    'Frutas',
    'Verduras',
    'Cereales',
    'Legumbres',
    'Hierbas',
    'Otros'
  ];
  static const List<String> units = [
    'kg',
    'gramos',
    'unidad',
    'docena',
    'litro',
    'manojo'
  ];
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onSurface,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
  );
  
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}