import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/badge.dart';
import '../models/scenario_result.dart';

class AchievementsProvider extends ChangeNotifier {
  List<SafetyBadge> _badges = [];
  List<ScenarioResult> _history = [];
  bool _isLoading = true;

  List<SafetyBadge> get badges => _badges;
  List<SafetyBadge> get unlockedBadges => _badges.where((b) => b.isUnlocked).toList();
  List<SafetyBadge> get lockedBadges => _badges.where((b) => !b.isUnlocked).toList();
  List<ScenarioResult> get history => _history;
  bool get isLoading => _isLoading;

  int get totalCompletedScenarios => _history.length;
  int get bestScore => _history.isEmpty
      ? 0
      : _history.map((e) => e.overallScore).reduce((a, b) => a > b ? a : b);

  Future<void> loadAchievements(String profileId) async {
    _isLoading = true;

    try {
      _badges = await DatabaseHelper.instance.getBadgesForProfile(profileId);
      _history = await DatabaseHelper.instance.getResultsForProfile(profileId);
    } catch (e) {
      debugPrint('Error loading achievements: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
