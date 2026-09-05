import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/achievements_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/icon_helper.dart';
import '../../widgets/nano_image_widget.dart';
import 'profile_management_screen.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final profileId = appState.activeProfile?.id ?? 'p_father';
    Provider.of<AchievementsProvider>(context, listen: false).loadAchievements(profileId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achProvider = Provider.of<AchievementsProvider>(context);
    final appState = Provider.of<AppStateProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = appState.activeProfile;

    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final levelProgress = AppConstants.calculateLevelProgress(profile.xp);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('achievements')),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            tooltip: loc.translate('familyMode'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileManagementScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // User Level & XP Hero Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: CustomCard(
              gradient: AppColors.heroGradient,
              child: Column(
                children: [
                  Row(
                    children: [
                      NanoImageWidget(
                        imageSource: profile.avatar,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(27),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              loc.isArabic ? profile.levelTitleAr : profile.levelTitleEn,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${loc.translate('level')} ${profile.level}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // XP & Progress Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'إجمالي نقاط الخبرة: ${profile.xp} XP',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${(levelProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.secondaryLight,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: levelProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Quick Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat('التدريبات', '${achProvider.totalCompletedScenarios}'),
                      Container(width: 1, height: 24, color: Colors.white24),
                      _buildMiniStat('الأوسمة', '${achProvider.unlockedBadges.length} / ${achProvider.badges.length}'),
                      Container(width: 1, height: 24, color: Colors.white24),
                      _buildMiniStat('أعلى درجة', '${achProvider.bestScore}%'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Tabs: الأوسمة والإنجازات | سجل التدريبات
          TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            tabs: [
              Tab(text: loc.translate('badges')),
              Tab(text: loc.translate('simulationHistory')),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Badges Grid
                achProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.95,
                        ),
                        itemCount: achProvider.badges.length,
                        itemBuilder: (context, index) {
                          final badge = achProvider.badges[index];
                          final isUnlocked = badge.isUnlocked;

                          return CustomCard(
                            color: isUnlocked
                                ? (isDark ? AppColors.surfaceDark : Colors.white)
                                : (isDark ? const Color(0xFF141916) : const Color(0xFFEEEEEE)),
                            border: Border.all(
                              color: isUnlocked
                                  ? AppColors.secondary
                                  : (isDark ? AppColors.borderDark : Colors.black12),
                              width: isUnlocked ? 1.5 : 1,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isUnlocked
                                        ? AppColors.secondary.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.2),
                                  ),
                                  child: Icon(
                                    IconHelper.getIcon(badge.icon),
                                    color: isUnlocked ? AppColors.secondaryDark : Colors.grey,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  loc.isArabic ? badge.titleAr : badge.titleEn,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isUnlocked
                                        ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                                        : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  loc.isArabic ? badge.descriptionAr : badge.descriptionEn,
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    color: isUnlocked
                                        ? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight)
                                        : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isUnlocked
                                        ? AppColors.safeGreenLight
                                        : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    isUnlocked ? 'مكتمل ✅' : 'مغلق 🔒',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: isUnlocked ? AppColors.safeGreen : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                // Tab 2: Simulation History
                achProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : achProvider.history.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.history_edu, size: 64, color: AppColors.textTertiaryLight),
                                const SizedBox(height: 12),
                                Text(
                                  loc.translate('noHistoryYet'),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
                            itemCount: achProvider.history.length,
                            itemBuilder: (context, index) {
                              final item = achProvider.history[index];
                              final dateStr = DateFormat('yyyy/MM/dd - hh:mm a').format(item.completedAt);
                              final catColor = AppColors.getCategoryColor(item.categoryId);

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: CustomCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            loc.isArabic ? item.scenarioTitleAr : item.scenarioTitleEn,
                                            style: TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: catColor.withOpacity(0.12),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '${item.overallScore}%',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: catColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            dateStr,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                            ),
                                          ),
                                          Text(
                                            '+${item.xpEarned} XP',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.secondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
