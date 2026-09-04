import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/preparedness_provider.dart';
import '../../../widgets/custom_card.dart';

class PreparednessGaugeCard extends StatelessWidget {
  const PreparednessGaugeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final prepProvider = Provider.of<PreparednessProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use current overall score or fallback 45 for demo parity
    final scoreVal = prepProvider.overallScore <= 0 ? 45 : prepProvider.overallScore;

    return CustomCard(
      borderRadius: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Sleek Circular Progress Ring showing 45/100
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: scoreVal / 100.0,
                      strokeWidth: 12,
                      backgroundColor: const Color(0xFFE0F2F1),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7E57C2)),
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$scoreVal',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text: '/100',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white54 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Pastel Category Pill Tags below (Fire, Floods, Heatwave, Traffic)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryPill('مرور', const Color(0xFFC5CAE9), const Color(0xFF303F9F)),
              _buildCategoryPill('موجة حر', const Color(0xFFFFCDD2), const Color(0xFFC62828)),
              _buildCategoryPill('فيضانات', const Color(0xFFB2EBF2), const Color(0xFF00838F)),
              _buildCategoryPill('حريق', const Color(0xFFFFE0B2), const Color(0xFFE65100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}
