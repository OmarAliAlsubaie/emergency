import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/animated_score_gauge.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/radar_metric_bar.dart';
import '../main_navigation_screen.dart';
import 'categories_screen.dart';
import 'scenario_runner_screen.dart';

class SimulationResultScreen extends StatefulWidget {
  const SimulationResultScreen({super.key});

  @override
  State<SimulationResultScreen> createState() => _SimulationResultScreenState();
}

class _SimulationResultScreenState extends State<SimulationResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.playLevelUpCelebration();
    });
  }

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final result = simProvider.lastResult;
    final scenario = simProvider.currentScenario;

    if (result == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                (route) => false,
              );
            },
            child: Text(loc.translate('backToHome')),
          ),
        ),
      );
    }

    final isSuccess = result.overallScore >= 70;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('simulationComplete')),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Success Badge
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSuccess ? AppColors.safeGreenLight : AppColors.warningOrangeLight,
                  border: Border.all(
                    color: isSuccess ? AppColors.safeGreen : AppColors.warningOrange,
                    width: 2,
                  ),
                ),
                child: Icon(
                  isSuccess ? Icons.military_tech : Icons.refresh,
                  size: 40,
                  color: isSuccess ? AppColors.safeGreen : AppColors.warningOrange,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              loc.isArabic ? result.scenarioTitleAr : result.scenarioTitleEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+${result.xpEarned} XP مكتسبة',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Overall Score Gauge Card
            CustomCard(
              child: Column(
                children: [
                  AnimatedScoreGauge(
                    score: result.overallScore,
                    size: 160,
                    label: loc.translate('yourScore'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'الوقت المستغرق: ${result.timeTakenSeconds} ${loc.translate('seconds')}',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4-Dimension Metric Breakdown
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تحليل مؤشرات الأداء التفصيلي',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RadarMetricBar(
                    title: loc.translate('decisionSpeed'),
                    score: result.decisionSpeedScore,
                    icon: Icons.speed,
                  ),
                  RadarMetricBar(
                    title: loc.translate('safety'),
                    score: result.safetyScore,
                    icon: Icons.shield,
                  ),
                  RadarMetricBar(
                    title: loc.translate('knowledge'),
                    score: result.knowledgeScore,
                    icon: Icons.school,
                  ),
                  RadarMetricBar(
                    title: loc.translate('response'),
                    score: result.responseScore,
                    icon: Icons.bolt,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Newly Unlocked Badges (if any)
            if (simProvider.newlyUnlockedBadges.isNotEmpty) ...[
              CustomCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)],
                ),
                border: Border.all(color: AppColors.secondary, width: 1.5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars, color: AppColors.secondaryDark, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          loc.translate('badgeUnlocked'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...simProvider.newlyUnlockedBadges.map((badge) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.secondary,
                          ),
                          child: const Icon(Icons.military_tech, color: Colors.white, size: 20),
                        ),
                        title: Text(
                          loc.isArabic ? badge.titleAr : badge.titleEn,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          loc.isArabic ? badge.descriptionAr : badge.descriptionEn,
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Strengths, Improvements, Advice Cards
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Strengths
                  Row(
                    children: [
                      const Icon(Icons.thumb_up_alt_rounded, color: AppColors.safeGreen, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate('strengths'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.safeGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.isArabic ? result.strengthsAr : result.strengthsEn,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),

                  const Divider(height: 24),

                  // Areas for Improvement
                  Row(
                    children: [
                      const Icon(Icons.upgrade_rounded, color: AppColors.warningOrange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate('areasForImprovement'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.warningOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.isArabic ? result.improvementsAr : result.improvementsEn,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),

                  const Divider(height: 24),

                  // Educational Advice
                  Row(
                    children: [
                      const Icon(Icons.tips_and_updates, color: AppColors.infoBlue, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        loc.translate('educationalAdvice'),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.infoBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.isArabic ? result.adviceAr : result.adviceEn,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Buttons: Retry, Another Simulation, Back to Home
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (scenario != null) {
                        simProvider.startScenario(scenario, timerEnabled: langProvider.timerEnabled);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScenarioRunnerScreen(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.replay_rounded, size: 18),
                    label: Text(loc.translate('retrySimulation')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      simProvider.reset();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoriesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.dashboard_customize_rounded, size: 18),
                    label: Text(loc.translate('anotherSimulation')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                simProvider.reset();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                  (route) => false,
                );
              },
              child: Text(
                loc.translate('backToHome'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
