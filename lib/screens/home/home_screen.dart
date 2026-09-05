import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/preparedness_provider.dart';
import '../../widgets/custom_card.dart';
import '../knowledge/knowledge_screen.dart';
import '../emergency/emergency_info_screen.dart';
import '../simulation/categories_screen.dart';
import '../inspection/home_safety_inspector_screen.dart';
import '../safety_packs/highway_car_checklist_screen.dart';
import '../../widgets/nano_image_widget.dart';
import '../../core/constants/nano_banana_assets.dart';
import 'widgets/profile_header_widget.dart';
import 'widgets/preparedness_gauge_card.dart';
import 'widgets/recent_training_card.dart';
import 'widgets/daily_challenge_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return RefreshIndicator(
      onRefresh: () async {
        final appState = Provider.of<AppStateProvider>(context, listen: false);
        if (appState.activeProfile != null) {
          await Provider.of<PreparednessProvider>(context, listen: false)
              .loadPreparednessData(appState.activeProfile!.id);
        }
      },
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(18, topPadding + 10, 18, 100),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Profile Header
                const ProfileHeaderWidget(),

                const SizedBox(height: 18),

                // 2. Main CTA Hero Button "ابدأ محاكاة" (Mint Green Action Banner: Raised 3X Large 265px Officer on LEFT)
                Container(
                  height: 135,
                  decoration: BoxDecoration(
                    color: const Color(0xFFA2E8DD),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFA2E8DD).withOpacity(0.55),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Giant Hero Officer Character flush attached to bottom (bottom: 0) - Increased 40%
                      const Positioned(
                        left: -15,
                        bottom: 0,
                        child: SizedBox(
                          height: 385,
                          width: 275,
                          child: NanoImageWidget(
                            imageSource: NanoBananaAssets.officerNoBg,
                            width: 275,
                            height: 385,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomLeft,
                          ),
                        ),
                      ),

                      // InkWell Action Layer
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(26),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            child: Row(
                              children: [
                                // Item 1 (FAR RIGHT in Arabic): White Circular Play Button
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Color(0xFF00796B),
                                    size: 38,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Item 2 (MIDDLE): CTA Text Block with Colored Lightning Icon
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.translate('startSimulation'),
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF004D25),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            loc.isArabic ? 'اختر التحدي واختبر جاهزيتك' : 'Choose challenge & test readiness',
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF00695C),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.bolt_rounded,
                                            color: Color(0xFFFFB700),
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Item 3 (FAR LEFT in Arabic): Reserved space for Officer anchored on left
                                const SizedBox(width: 175),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 3. Preparedness Score Card
                const PreparednessGaugeCard(),

                const SizedBox(height: 14),

                // 4. Daily Challenge Card
                const DailyChallengeCard(),

                const SizedBox(height: 14),

                // 5. Recent Training Card
                const RecentTrainingCard(),

                const SizedBox(height: 18),

                // 6. Interactive Safety Tools Grid
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'أدوات السلامة المتخصصة',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.45,
                  children: [
                    // Home Inspector
                    CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeSafetyInspectorScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.home_work_outlined, color: AppColors.primary, size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'مفتش السلامة المنزلية',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'فحص الغرف ومؤشر %',
                            style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Desert Safety Challenge
                    CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.landscape, color: Colors.amber, size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'تحديات البر والسيول',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'تمارين النجاة والكشتات',
                            style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Highway Car Checklist
                    CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HighwayCarChecklistScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.directions_car, color: AppColors.secondary, size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'فحص سيارة الخطوط',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'السبير والطفايات قبل السفر',
                            style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                          ),
                        ],
                      ),
                    ),

                    // Cyber Security Challenge
                    CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.security, color: Color(0xFF6366F1), size: 24),
                          const SizedBox(height: 8),
                          const Text(
                            'تحديات الأمن الرقمي',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'تمارين الاحتيال البنكي و 2FA',
                            style: TextStyle(fontSize: 10.5, color: isDark ? Colors.white60 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 7. Quick Emergency & Knowledge Shortcuts
                Row(
                  children: [
                    Expanded(
                      child: CustomCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmergencyInfoScreen(),
                            ),
                          );
                        },
                        color: isDark ? const Color(0xFF2B1414) : const Color(0xFFFFEBEE),
                        border: Border.all(
                          color: AppColors.emergencyRed.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyRed.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.phone_in_talk,
                                color: AppColors.emergencyRed,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              loc.translate('emergencyNumbers'),
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFFFF8A80) : AppColors.emergencyRed,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '911 - 998 - 997',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const KnowledgeScreen(),
                            ),
                          );
                        },
                        color: isDark ? const Color(0xFF14242B) : const Color(0xFFE1F5FE),
                        border: Border.all(
                          color: AppColors.infoBlue.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.infoBlue.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: AppColors.infoBlue,
                                size: 22,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              loc.translate('knowledgeCenter'),
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF80D8FF) : AppColors.infoBlue,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'إرشادات وخطط إنقاذ',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
  }
}
