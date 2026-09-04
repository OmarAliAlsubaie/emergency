import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/knowledge_article.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/knowledge_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/icon_helper.dart';

class ArticleDetailScreen extends StatelessWidget {
  final KnowledgeArticle article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final knowProvider = Provider.of<KnowledgeProvider>(context);
    final appState = Provider.of<AppStateProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(article.categoryId);
    final profileId = appState.activeProfile?.id ?? 'p_father';

    final isBookmarked = knowProvider.articles
        .firstWhere((a) => a.id == article.id, orElse: () => article)
        .isBookmarked;

    final steps = loc.isArabic ? article.stepsAr : article.stepsEn;
    final dos = loc.isArabic ? article.doListAr : article.doListEn;
    final donts = loc.isArabic ? article.dontListAr : article.dontListEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('knowledgeCenter')),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? AppColors.secondary : null,
            ),
            onPressed: () {
              knowProvider.toggleBookmark(profileId, article.id, isBookmarked);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Article Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [catColor.withOpacity(0.85), catColor],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              '${article.readingTimeMinutes} دقائق قراءة',
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(IconHelper.getIcon(article.icon), color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.isArabic ? article.titleAr : article.titleEn,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Summary & Introduction
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نظرة عامة',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    loc.isArabic ? article.contentAr : article.contentEn,
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Step by Step Instructions
            if (steps.isNotEmpty) ...[
              Text(
                loc.translate('stepByStep'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(steps.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: catColor.withOpacity(0.15),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: catColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            steps[index],
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],

            // Do's Card
            if (dos.isNotEmpty) ...[
              CustomCard(
                color: isDark ? const Color(0xFF14291B) : const Color(0xFFE8F5E9),
                border: Border.all(color: AppColors.safeGreen.withOpacity(0.4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppColors.safeGreen, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.translate('doList'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.safeGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...dos.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✅ ', style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
            ],

            // Don'ts Card
            if (donts.isNotEmpty) ...[
              CustomCard(
                color: isDark ? const Color(0xFF2C1414) : const Color(0xFFFFEBEE),
                border: Border.all(color: AppColors.emergencyRed.withOpacity(0.4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cancel_outlined, color: AppColors.emergencyRed, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          loc.translate('dontList'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.emergencyRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...donts.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('❌ ', style: TextStyle(fontSize: 12)),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
