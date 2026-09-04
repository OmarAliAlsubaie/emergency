import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/preparedness_provider.dart';
import '../../widgets/animated_score_gauge.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/icon_helper.dart';
import 'categories_screen.dart';

class PreparednessDetailScreen extends StatelessWidget {
  const PreparednessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prepProvider = Provider.of<PreparednessProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('readinessScore')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Gauge Card
            CustomCard(
              child: Column(
                children: [
                  AnimatedScoreGauge(
                    score: prepProvider.overallScore,
                    size: 175,
                    label: 'مؤشر الجاهزية الإجمالي',
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'تم احتساب درجتك محلياً بناءً على دقة قراراتك وسرعة استجابتك في السيناريوهات المنفذة دون الحاجة لأي اتصال بالإنترنت.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'توزيع الجاهزية حسب مجالات الطوارئ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),

            const SizedBox(height: 12),

            // Category Breakdown List
            ...prepProvider.categoryScores.map((cat) {
              final catColor = AppColors.getCategoryColor(cat.categoryId);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: catColor.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              IconHelper.getIcon(cat.icon),
                              color: catColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loc.isArabic ? cat.titleAr : cat.titleEn,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  cat.completedCount > 0
                                      ? 'تم إكمال ${cat.completedCount} سيناريوهات'
                                      : 'لم يكتمل أي تدريب بعد',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${cat.score}%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: catColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (cat.score / 100.0).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: isDark ? const Color(0xFF28362E) : const Color(0xFFE2EBE5),
                          valueColor: AlwaysStoppedAnimation<Color>(catColor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),

            // How to Improve
            CustomCard(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1B2E24), const Color(0xFF101E17)]
                    : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
              ),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.rocket_launch, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'كيف ترفع درجة جاهزيتك إلى 100%؟',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.primaryLight : AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. خوض محاكاة جديدة في المجالات التي تقل عن 70%.\n'
                    '2. اتخاذ القرارات في أقل من 10 ثوانٍ لرفع مؤشر السرعة.\n'
                    '3. قراءة الإرشادات في مركز المعرفة واستيعاب قواعد السلامة.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoriesScreen(),
                          ),
                        );
                      },
                      child: const Text('بدء تدريب لرفع الجاهزية'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
