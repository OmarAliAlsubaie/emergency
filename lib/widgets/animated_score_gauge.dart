import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AnimatedScoreGauge extends StatefulWidget {
  final int score; // 0 - 100
  final double size;
  final String label;
  final bool showGrade;

  const AnimatedScoreGauge({
    super.key,
    required this.score,
    this.size = 170,
    this.label = 'درجة الجاهزية',
    this.showGrade = true,
  });

  @override
  State<AnimatedScoreGauge> createState() => _AnimatedScoreGaugeState();
}

class _AnimatedScoreGaugeState extends State<AnimatedScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.score / 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score / 100.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGrade(int score) {
    if (score >= 90) return 'جاهزية استثنائية 🛡️';
    if (score >= 80) return 'جاهزية عالية ⭐';
    if (score >= 65) return 'مستوى مقبول 👍';
    return 'بحاجة لمزيد من التدريب ⚠️';
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return AppColors.primary;
    if (score >= 70) return AppColors.secondary;
    if (score >= 50) return AppColors.warningOrange;
    return AppColors.emergencyRed;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = (_animation.value * 100).round();
        final scoreColor = _getScoreColor(currentScore);

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  progress: _animation.value,
                  isDark: isDark,
                  primaryColor: scoreColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$currentScore',
                        style: TextStyle(
                          fontSize: widget.size * 0.24,
                          fontWeight: FontWeight.w900,
                          color: scoreColor,
                          height: 1,
                        ),
                      ),
                      Text(
                        ' / 100',
                        style: TextStyle(
                          fontSize: widget.size * 0.09,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.size * 0.075,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (widget.showGrade) ...[
                    const SizedBox(height: 2),
                    Text(
                      _getGrade(currentScore),
                      style: TextStyle(
                        fontSize: widget.size * 0.065,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final bool isDark;
  final Color primaryColor;

  _GaugePainter({
    required this.progress,
    required this.isDark,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 24) / 2;
    const startAngle = 0.75 * pi;
    const sweepTotalAngle = 1.5 * pi;
    const strokeWidth = 14.0;

    // Track Paint (Background Arc)
    final trackPaint = Paint()
      ..color = isDark ? const Color(0xFF28362E) : const Color(0xFFE2EBE5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotalAngle,
      false,
      trackPaint,
    );

    // Active Progress Arc with Gradient
    if (progress > 0) {
      final sweepProgressAngle = sweepTotalAngle * progress;
      final activePaint = Paint()
        ..shader = SweepGradient(
          startAngle: startAngle,
          endAngle: startAngle + sweepTotalAngle,
          colors: [
            AppColors.secondary,
            primaryColor,
          ],
          transform: GradientRotation(startAngle),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepProgressAngle,
        false,
        activePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.primaryColor != primaryColor;
  }
}
