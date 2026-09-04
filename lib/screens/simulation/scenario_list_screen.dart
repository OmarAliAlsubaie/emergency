import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/database/database_helper.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/category.dart';
import '../../models/scenario.dart';
import '../../providers/simulation_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/nano_image_widget.dart';
import '../../widgets/scenario_banner_widget.dart';
import '../../widgets/status_badge.dart';
import 'scenario_runner_screen.dart';


class ScenarioListScreen extends StatefulWidget {
  final SimulationCategory category;

  const ScenarioListScreen({super.key, required this.category});

  @override
  State<ScenarioListScreen> createState() => _ScenarioListScreenState();
}

class _ScenarioListScreenState extends State<ScenarioListScreen> {
  List<Scenario> _scenarios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScenarios();
  }

  Future<void> _loadScenarios() async {
    final list = await DatabaseHelper.instance.getScenariosByCategory(widget.category.id);
    if (mounted) {
      setState(() {
        _scenarios = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final catColor = AppColors.getCategoryColor(widget.category.id);
    final simProvider = Provider.of<SimulationProvider>(context, listen: false);
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.isArabic ? widget.category.titleAr : widget.category.titleEn),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _scenarios.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.layers_clear, size: 64, color: AppColors.textTertiaryLight),
                      const SizedBox(height: 12),
                      Text(
                        'لا توجد سيناريوهات حالياً في هذا المجال',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                      child: ScenarioBannerWidget(
                        categoryId: widget.category.id,
                        height: 150,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        itemCount: _scenarios.length,
                        itemBuilder: (context, index) {
                    final sc = _scenarios[index];

                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: 14),
                      onTap: () {
                        simProvider.startScenario(sc, timerEnabled: langProvider.timerEnabled);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScenarioRunnerScreen(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge.difficulty(difficulty: sc.difficulty),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppColors.textTertiaryLight),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${sc.timeLimitSeconds} ${loc.translate('seconds')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NanoImageWidget(
                                imageSource: 'cat_${widget.category.id}',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.isArabic ? sc.titleAr : sc.titleEn,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      loc.isArabic ? sc.descriptionAr : sc.descriptionEn,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${sc.steps.length} محطات قرار تفاعلية',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  simProvider.startScenario(sc, timerEnabled: langProvider.timerEnabled);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ScenarioRunnerScreen(),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.play_arrow, size: 18),
                                label: const Text('بدء المحاكاة'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: catColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ],
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
