import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/scenario_result.dart';
import '../models/scenario.dart';

class CategoryPreparedness {
  final String categoryId;
  final String titleAr;
  final String titleEn;
  final String icon;
  final int score; // 0 - 100
  final int completedCount;

  CategoryPreparedness({
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.score,
    required this.completedCount,
  });
}

class PreparednessProvider extends ChangeNotifier {
  int _overallScore = 65;
  List<CategoryPreparedness> _categoryScores = [];
  ScenarioResult? _lastTraining;
  Scenario? _dailyChallengeScenario;
  bool _isLoading = true;

  int get overallScore => _overallScore;
  List<CategoryPreparedness> get categoryScores => _categoryScores;
  ScenarioResult? get lastTraining => _lastTraining;
  Scenario? get dailyChallengeScenario => _dailyChallengeScenario;
  bool get isLoading => _isLoading;

  Future<void> loadPreparednessData(String profileId) async {
    _isLoading = true;

    try {
      final results = await DatabaseHelper.instance.getResultsForProfile(profileId);
      final categories = await DatabaseHelper.instance.getAllCategories();
      final allScenarios = await DatabaseHelper.instance.getAllScenarios();

      _lastTraining = await DatabaseHelper.instance.getLatestResultForProfile(profileId);

      // Daily challenge selection (deterministic based on day of year)
      if (allScenarios.isNotEmpty) {
        final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
        final index = dayOfYear % allScenarios.length;
        _dailyChallengeScenario = allScenarios[index];
      }

      // Calculate score per category
      final Map<String, List<int>> catScoresMap = {};
      for (final r in results) {
        catScoresMap.putIfAbsent(r.categoryId, () => []).add(r.overallScore);
      }

      final List<CategoryPreparedness> calculated = [];
      int cumulativeScore = 0;
      int scoredCatCount = 0;

      for (final cat in categories) {
        final scores = catScoresMap[cat.id] ?? [];
        int catScore = 50; // Base baseline readiness
        if (scores.isNotEmpty) {
          final avg = scores.reduce((a, b) => a + b) ~/ scores.length;
          catScore = avg;
          cumulativeScore += catScore;
          scoredCatCount++;
        } else {
          cumulativeScore += 50;
          scoredCatCount++;
        }

        calculated.add(CategoryPreparedness(
          categoryId: cat.id,
          titleAr: cat.titleAr,
          titleEn: cat.titleEn,
          icon: cat.icon,
          score: catScore.clamp(0, 100),
          completedCount: scores.length,
        ));
      }

      _categoryScores = calculated;
      if (scoredCatCount > 0) {
        _overallScore = (cumulativeScore / scoredCatCount).round().clamp(0, 100);
      } else {
        _overallScore = 60;
      }
    } catch (e) {
      debugPrint('Error loading preparedness: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
