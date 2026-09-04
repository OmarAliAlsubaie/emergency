import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class RadarMetricBar extends StatelessWidget {
  final String title;
  final int score; // 0 - 100
  final IconData icon;
  final Color? color;

  const RadarMetricBar({
    super.key,
    required this.title,
    required this.score,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final metricColor = color ?? (score >= 80 ? AppColors.primary : (score >= 60 ? AppColors.secondary : AppColors.emergencyRed));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: metricColor),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              Text(
                '$score%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: metricColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (score / 100.0).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: isDark ? const Color(0xFF28362E) : const Color(0xFFE2EBE5),
              valueColor: AlwaysStoppedAnimation<Color>(metricColor),
            ),
          ),
        ],
      ),
    );
  }
}
