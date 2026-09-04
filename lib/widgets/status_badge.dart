import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const StatusBadge({
    super.key,
    required this.label,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.fontSize = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  factory StatusBadge.safe({required String label}) {
    return StatusBadge(
      label: label,
      icon: Icons.check_circle,
      backgroundColor: AppColors.safeGreenLight,
      textColor: AppColors.safeGreen,
    );
  }

  factory StatusBadge.unsafe({required String label}) {
    return StatusBadge(
      label: label,
      icon: Icons.warning_amber_rounded,
      backgroundColor: AppColors.emergencyRedLight,
      textColor: AppColors.emergencyRed,
    );
  }

  factory StatusBadge.difficulty({required String difficulty}) {
    Color bg;
    Color fg;
    if (difficulty == 'مبتدئ' || difficulty == 'Beginner') {
      bg = const Color(0xFFE8F5E9);
      fg = const Color(0xFF2E7D32);
    } else if (difficulty == 'متوسط' || difficulty == 'Intermediate') {
      bg = const Color(0xFFFFF3E0);
      fg = const Color(0xFFE65100);
    } else {
      bg = const Color(0xFFFFEBEE);
      fg = const Color(0xFFC62828);
    }

    return StatusBadge(
      label: difficulty,
      backgroundColor: bg,
      textColor: fg,
      fontSize: 11,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
