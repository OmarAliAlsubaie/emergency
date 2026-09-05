import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/app_colors.dart';
import '../../models/scenario_option.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/preparedness_provider.dart';
import '../../providers/achievements_provider.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/icon_helper.dart';
import '../../widgets/nano_image_widget.dart';
import '../../core/constants/nano_banana_assets.dart';
import 'simulation_result_screen.dart';

String _getCategoryIllustration(String categoryId) {
  switch (categoryId) {
    case 'fire':
      return NanoBananaAssets.catFire;
    case 'flood':
      return NanoBananaAssets.catFlood;
    case 'heat':
      return NanoBananaAssets.catHeat;
    case 'traffic':
      return NanoBananaAssets.catTraffic;
    case 'home':
      return NanoBananaAssets.catHome;
    case 'evacuation':
      return NanoBananaAssets.catEvacuation;
    case 'electric':
      return NanoBananaAssets.catElectric;
    case 'desert_safety':
      return NanoBananaAssets.catDesert;
    case 'cyber_safety':
      return NanoBananaAssets.catCyber;
    case 'emergency_kit':
    default:
      return NanoBananaAssets.catEmergencyKit;
  }
}

class ScenarioRunnerScreen extends StatefulWidget {
  const ScenarioRunnerScreen({super.key});

  @override
  State<ScenarioRunnerScreen> createState() => _ScenarioRunnerScreenState();
}

class _ScenarioRunnerScreenState extends State<ScenarioRunnerScreen> {
  int _lastPlayedStepIndex = -1;

  void _showFeedbackModal(BuildContext context, ScenarioOption option) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final simProvider = Provider.of<SimulationProvider>(context, listen: false);
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    final isSafe = option.isSafe;
    if (isSafe) {
      AudioService.instance.playSuccess();
    } else {
      AudioService.instance.playError();
    }

    final isLastStep = (simProvider.currentStepIndex + 1) >= simProvider.totalSteps;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Safe/Unsafe Banner Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSafe
                        ? AppColors.safeGreenLight
                        : AppColors.emergencyRedLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSafe ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                        color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSafe
                                  ? loc.translate('safeDecision')
                                  : loc.translate('unsafeDecision'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isSafe
                                  ? '+${option.xpReward} XP • أداء ممتاز'
                                  : '0 XP • انتبه للمخاطر',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Outcome / Consequence
                if (option.outcomeSummaryAr.isNotEmpty) ...[
                  Text(
                    loc.translate('consequence'),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceElevatedDark : const Color(0xFFF7F9F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loc.isArabic ? option.outcomeSummaryAr : option.outcomeSummaryEn,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Why This Decision (Scientific Explanation)
                Text(
                  loc.translate('whyThisDecision'),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceElevatedDark : const Color(0xFFF7F9F8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    loc.isArabic ? option.explanationAr : option.explanationEn,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Action Continue Button
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final activeId = appState.activeProfile?.id ?? '';
                    if (activeId.isEmpty) return;
                    await simProvider.nextStepOrFinish(activeId, timerEnabled: langProvider.timerEnabled);

                    if (isLastStep && context.mounted) {
                      // Refresh dashboard providers & active profile stats
                      await appState.refreshActiveProfile();
                      if (context.mounted) {
                        Provider.of<PreparednessProvider>(context, listen: false).loadPreparednessData(activeId);
                        Provider.of<AchievementsProvider>(context, listen: false).loadAchievements(activeId);
                      }

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SimulationResultScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSafe ? AppColors.primary : AppColors.warningOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    isLastStep
                        ? loc.translate('finishSimulation')
                        : loc.translate('nextStep'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final simProvider = Provider.of<SimulationProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final scenario = simProvider.currentScenario;
    final step = simProvider.currentStep;

    if (scenario != null && simProvider.currentStepIndex != _lastPlayedStepIndex) {
      _lastPlayedStepIndex = simProvider.currentStepIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AudioService.instance.playStationSound(scenario.categoryId, stepIndex: simProvider.currentStepIndex);
      });
    }

    if (scenario == null || step == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(loc.translate('simulations')),
            ],
          ),
        ),
      );
    }

    final catColor = AppColors.getCategoryColor(scenario.categoryId);
    final currentStepNum = simProvider.currentStepIndex + 1;
    final totalStepsNum = simProvider.totalSteps;
    final progressVal = currentStepNum / (totalStepsNum > 0 ? totalStepsNum : 1);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('إنهاء المحاكاة؟'),
            content: const Text('هل أنت متأكد من مغادرة المحاكاة الحالية؟ ستفقد التقدم غير المحفوظ.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(loc.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
                child: const Text('خروج'),
              ),
            ],
          ),
        );
        if (shouldExit == true) {
          simProvider.reset();
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.isArabic ? scenario.titleAr : scenario.titleEn),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Progress & Live Timer Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'المحطة $currentStepNum من $totalStepsNum',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        // Live Countdown Timer
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: simProvider.remainingSeconds <= 5
                                ? AppColors.emergencyRed.withOpacity(0.15)
                                : AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: simProvider.remainingSeconds <= 5
                                  ? AppColors.emergencyRed
                                  : AppColors.primary,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: simProvider.remainingSeconds <= 5
                                    ? AppColors.emergencyRed
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${simProvider.remainingSeconds} ${loc.translate('seconds')}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: simProvider.remainingSeconds <= 5
                                      ? AppColors.emergencyRed
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progressVal,
                        minHeight: 6,
                        backgroundColor: isDark ? const Color(0xFF2E4037) : const Color(0xFFE0E5E2),
                        valueColor: AlwaysStoppedAnimation<Color>(catColor),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Situation & Decision Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Situation Graphic Banner
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              catColor.withOpacity(0.9),
                              catColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: catColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Offline SVG Illustration Visual Asset
                            ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.2),
                                child: NanoImageWidget(
                                  imageSource: _getCategoryIllustration(scenario.categoryId),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 140,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    IconHelper.getIcon(step.visualTheme),
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'الموقف الطارئ #${step.stepOrder}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              loc.isArabic ? step.situationAr : step.situationEn,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Decision Question Prompt
                      Text(
                        loc.translate('decision'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 4 Decision Options
                      ...List.generate(simProvider.currentStepOptions.length, (optIndex) {
                        final option = simProvider.currentStepOptions[optIndex];
                        final optionLetter = ['أ', 'ب', 'ج', 'د'][optIndex % 4];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: CustomCard(
                            onTap: () {
                              AudioService.instance.playClick();
                              simProvider.selectOption(option);
                              _showFeedbackModal(context, option);
                            },
                            padding: const EdgeInsets.all(16),
                            border: Border.all(
                              color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              width: 1.2,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: catColor.withOpacity(0.12),
                                    border: Border.all(color: catColor.withOpacity(0.4)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      optionLetter,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: catColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    loc.isArabic ? option.textAr : option.textEn,
                                    style: TextStyle(
                                      fontSize: 14.5,
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

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    AudioService.instance.stopStationSound();
    super.dispose();
  }
}
