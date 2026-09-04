import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/knowledge_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/icon_helper.dart';
import 'article_detail_screen.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final profileId = appState.activeProfile?.id ?? 'p_father';
    Provider.of<KnowledgeProvider>(context, listen: false).loadKnowledge(profileId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final knowProvider = Provider.of<KnowledgeProvider>(context);
    final appState = Provider.of<AppStateProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profileId = appState.activeProfile?.id ?? 'p_father';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('knowledgeCenter')),
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  controller: _searchController,
                  onChanged: (val) => knowProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: loc.translate('searchArticles'),
                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              knowProvider.setSearchQuery('');
                            },
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 12),

                // Category Chips
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // All Chip
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          label: const Text('الكل'),
                          selected: knowProvider.selectedCategoryId == 'all' && !knowProvider.onlyBookmarks,
                          onSelected: (selected) {
                            if (knowProvider.onlyBookmarks) knowProvider.toggleOnlyBookmarks();
                            knowProvider.selectCategory('all');
                          },
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: (knowProvider.selectedCategoryId == 'all' && !knowProvider.onlyBookmarks)
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Bookmarks Filter Chip
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: FilterChip(
                          avatar: Icon(
                            knowProvider.onlyBookmarks ? Icons.bookmark : Icons.bookmark_border,
                            size: 16,
                            color: knowProvider.onlyBookmarks ? Colors.white : AppColors.secondary,
                          ),
                          label: const Text('المحفوظات'),
                          selected: knowProvider.onlyBookmarks,
                          onSelected: (selected) {
                            knowProvider.toggleOnlyBookmarks();
                          },
                          selectedColor: AppColors.secondary,
                          labelStyle: TextStyle(
                            color: knowProvider.onlyBookmarks
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),

                      // Category Specific Chips
                      ...knowProvider.categories.map((cat) {
                        final isSelected = knowProvider.selectedCategoryId == cat.id && !knowProvider.onlyBookmarks;
                        final color = AppColors.getCategoryColor(cat.id);

                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: FilterChip(
                            label: Text(loc.isArabic ? cat.titleAr : cat.titleEn),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (knowProvider.onlyBookmarks) knowProvider.toggleOnlyBookmarks();
                              knowProvider.selectCategory(selected ? cat.id : 'all');
                            },
                            selectedColor: color,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Article List
          Expanded(
            child: knowProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : knowProvider.articles.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: AppColors.textTertiaryLight),
                            const SizedBox(height: 12),
                            Text(
                              'لم يتم العثور على مقالات مطابقة',
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        itemCount: knowProvider.articles.length,
                        itemBuilder: (context, index) {
                          final article = knowProvider.articles[index];
                          final catColor = AppColors.getCategoryColor(article.categoryId);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: CustomCard(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArticleDetailScreen(article: article),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: catColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(IconHelper.getIcon(article.icon), size: 14, color: catColor),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${article.readingTimeMinutes} دقائق قراءة',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: catColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          article.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                          color: article.isBookmarked ? AppColors.secondary : AppColors.textTertiaryLight,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          knowProvider.toggleBookmark(profileId, article.id, article.isBookmarked);
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    loc.isArabic ? article.titleAr : article.titleEn,
                                    style: TextStyle(
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    loc.isArabic ? article.summaryAr : article.summaryEn,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      height: 1.35,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${article.stepsAr.length} خطوات إجرائية',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'اقرأ الدليل',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: catColor,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.arrow_forward_ios, size: 12, color: catColor),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
