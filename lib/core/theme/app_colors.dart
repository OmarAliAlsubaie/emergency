import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette - Saudi Green & Elegant Emerald
  static const Color primary = Color(0xFF006C35); // Official Saudi Green tone
  static const Color primaryDark = Color(0xFF004D25);
  static const Color primaryLight = Color(0xFF0E8A49);
  static const Color primaryContainer = Color(0xFFE8F5E9);
  static const Color primaryContainerDark = Color(0xFF003318);

  // Secondary & Accents - Gold / Amber / Bronze
  static const Color secondary = Color(0xFFC59B27);
  static const Color secondaryLight = Color(0xFFE5C058);
  static const Color secondaryDark = Color(0xFF8F6D10);
  static const Color secondaryContainer = Color(0xFFFFF8E1);

  // Status & Emergency Colors
  static const Color emergencyRed = Color(0xFFD32F2F);
  static const Color emergencyRedLight = Color(0xFFFFEBEE);
  static const Color warningOrange = Color(0xFFE65100);
  static const Color warningOrangeLight = Color(0xFFFFF3E0);
  static const Color safeGreen = Color(0xFF2E7D32);
  static const Color safeGreenLight = Color(0xFFE8F5E9);
  static const Color infoBlue = Color(0xFF0277BD);
  static const Color infoBlueLight = Color(0xFFE1F5FE);

  // Background & Surfaces (Light)
  static const Color backgroundLight = Color(0xFFF7F9F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE0E5E2);

  // Background & Surfaces (Dark)
  static const Color backgroundDark = Color(0xFF101613);
  static const Color surfaceDark = Color(0xFF18221D);
  static const Color surfaceElevatedDark = Color(0xFF223029);
  static const Color borderDark = Color(0xFF2E4037);

  // Typography Colors
  static const Color textPrimaryLight = Color(0xFF1A2621);
  static const Color textSecondaryLight = Color(0xFF5A6E64);
  static const Color textTertiaryLight = Color(0xFF8FA399);

  static const Color textPrimaryDark = Color(0xFFF1F5F3);
  static const Color textSecondaryDark = Color(0xFFA5B8AE);
  static const Color textTertiaryDark = Color(0xFF6B8074);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF0E8A49), Color(0xFF004D25)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFF006C35), Color(0xFF00381B)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFE5C058), Color(0xFFB38612)],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
  );

  // Category Color Map
  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'fire':
        return const Color(0xFFE64A19);
      case 'flood':
        return const Color(0xFF0288D1);
      case 'heat':
        return const Color(0xFFF57C00);
      case 'traffic':
        return const Color(0xFF5E35B1);
      case 'home':
        return const Color(0xFF43A047);
      case 'evacuation':
        return const Color(0xFFD81B60);
      case 'electric':
        return const Color(0xFFFBC02D);
      case 'emergency_kit':
        return const Color(0xFF00897B);
      case 'desert_safety':
        return const Color(0xFFD97706); // Warm Amber/Desert Gold
      case 'cyber_safety':
        return const Color(0xFF6366F1); // Indigo / Cyber Security Blue
      default:
        return primary;
    }
  }
}
