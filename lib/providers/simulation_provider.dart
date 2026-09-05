import 'dart:async';
import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/scenario.dart';
import '../models/scenario_step.dart';
import '../models/scenario_option.dart';
import '../models/scenario_result.dart';
import '../models/badge.dart';

enum SimulationStatus { idle, running, stepFeedback, completed }

class SimulationProvider extends ChangeNotifier {
  Scenario? _currentScenario;
  int _currentStepIndex = 0;
  SimulationStatus _status = SimulationStatus.idle;
  int _remainingSeconds = 30;
  Timer? _timer;
  int _totalTimeTaken = 0;
  int _stepTimeTaken = 0;

  ScenarioOption? _selectedOption;
  final List<ScenarioOption> _chosenOptions = [];
  final List<int> _stepTimeSpent = [];
  List<ScenarioOption> _currentStepOptions = [];

  ScenarioResult? _lastResult;
  List<SafetyBadge> _newlyUnlockedBadges = [];

  Scenario? get currentScenario => _currentScenario;
  int get currentStepIndex => _currentStepIndex;
  SimulationStatus get status => _status;
  int get remainingSeconds => _remainingSeconds;
  ScenarioOption? get selectedOption => _selectedOption;
  ScenarioResult? get lastResult => _lastResult;
  List<SafetyBadge> get newlyUnlockedBadges => _newlyUnlockedBadges;
  List<ScenarioOption> get currentStepOptions => _currentStepOptions;

  ScenarioStep? get currentStep {
    if (_currentScenario == null ||
        _currentStepIndex >= _currentScenario!.steps.length) {
      return null;
    }
    return _currentScenario!.steps[_currentStepIndex];
  }

  int get totalSteps => _currentScenario?.steps.length ?? 0;

  void startScenario(Scenario scenario, {bool timerEnabled = true}) {
    _currentScenario = scenario;
    _currentStepIndex = 0;
    _chosenOptions.clear();
    _stepTimeSpent.clear();
    _selectedOption = null;
    _totalTimeTaken = 0;
    _newlyUnlockedBadges.clear();
    _status = SimulationStatus.running;

    _shuffleCurrentStepOptions();
    _startStepTimer(timerEnabled);
    notifyListeners();
  }

  void _shuffleCurrentStepOptions() {
    if (currentStep != null) {
      final list = List<ScenarioOption>.from(currentStep!.options);
      list.shuffle();
      _currentStepOptions = list;
    } else {
      _currentStepOptions = [];
    }
  }

  void _startStepTimer(bool timerEnabled) {
    _timer?.cancel();
    _remainingSeconds = (_currentScenario?.timeLimitSeconds != null && _currentScenario!.timeLimitSeconds > 0)
        ? _currentScenario!.timeLimitSeconds
        : 30;
    _stepTimeTaken = 0;

    if (!timerEnabled) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        _stepTimeTaken++;
        notifyListeners();
      } else {
        // Time expired: auto-select lowest safety choice or force timeout
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    _timer?.cancel();
    if (currentStep != null && currentStep!.options.isNotEmpty) {
      // Pick unsafe choice or default
      final unsafeOpt = currentStep!.options.firstWhere(
        (o) => !o.isSafe,
        orElse: () => currentStep!.options.first,
      );
      selectOption(unsafeOpt);
    }
  }

  void selectOption(ScenarioOption option) {
    if (_status != SimulationStatus.running) return;
    _timer?.cancel();

    _selectedOption = option;
    _chosenOptions.add(option);
    _stepTimeSpent.add(_stepTimeTaken);
    _totalTimeTaken += _stepTimeTaken;
    _status = SimulationStatus.stepFeedback;
    notifyListeners();
  }

  Future<void> nextStepOrFinish(String activeProfileId, {bool timerEnabled = true}) async {
    if (_currentScenario == null) return;

    if (_currentStepIndex + 1 < _currentScenario!.steps.length) {
      _currentStepIndex++;
      _selectedOption = null;
      _status = SimulationStatus.running;
      _shuffleCurrentStepOptions();
      _startStepTimer(timerEnabled);
      notifyListeners();
    } else {
      // Finish simulation and compute results
      await _calculateAndSaveResults(activeProfileId);
    }
  }

  Future<void> _calculateAndSaveResults(String profileId) async {
    _timer?.cancel();
    _status = SimulationStatus.completed;

    if (_currentScenario == null || _chosenOptions.isEmpty) return;

    int totalSafetyPoints = 0;
    int totalSpeedPoints = 0;
    int totalXpEarned = 0;

    for (int i = 0; i < _chosenOptions.length; i++) {
      final opt = _chosenOptions[i];
      final timeSpent = i < _stepTimeSpent.length ? _stepTimeSpent[i] : 10;
      final limit = _currentScenario!.timeLimitSeconds;

      totalSafetyPoints += opt.safetyScore;
      totalXpEarned += opt.xpReward;

      // Speed calculation: Faster answers within safety earn higher speed score
      double speedRatio = 1.0 - (timeSpent / limit).clamp(0.0, 1.0);
      if (opt.isSafe) {
        totalSpeedPoints += (speedRatio * 100).round();
      } else {
        totalSpeedPoints += (speedRatio * 30).round();
      }
    }

    final count = _chosenOptions.length;
    final avgSafety = (totalSafetyPoints / count).round().clamp(0, 100);
    final avgSpeed = (totalSpeedPoints / count).round().clamp(0, 100);
    final knowledgeScore = (_chosenOptions.where((o) => o.isSafe).length * 100 ~/ count).clamp(0, 100);
    final responseScore = ((avgSafety * 0.6) + (avgSpeed * 0.4)).round().clamp(0, 100);
    final overallScore = ((avgSafety * 0.5) + (knowledgeScore * 0.3) + (avgSpeed * 0.2)).round().clamp(0, 100);

    totalXpEarned += 50; // Completion bonus XP

    // Generate educational feedback
    final feedback = _generateFeedback(overallScore, avgSafety, avgSpeed, _currentScenario!.categoryId);

    final result = ScenarioResult(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      profileId: profileId,
      scenarioId: _currentScenario!.id,
      scenarioTitleAr: _currentScenario!.titleAr,
      scenarioTitleEn: _currentScenario!.titleEn,
      categoryId: _currentScenario!.categoryId,
      overallScore: overallScore,
      decisionSpeedScore: avgSpeed,
      safetyScore: avgSafety,
      knowledgeScore: knowledgeScore,
      responseScore: responseScore,
      timeTakenSeconds: _totalTimeTaken,
      xpEarned: totalXpEarned,
      strengthsAr: feedback['strengthsAr']!,
      strengthsEn: feedback['strengthsEn']!,
      improvementsAr: feedback['improvementsAr']!,
      improvementsEn: feedback['improvementsEn']!,
      adviceAr: feedback['adviceAr']!,
      adviceEn: feedback['adviceEn']!,
      completedAt: DateTime.now(),
    );

    _lastResult = result;

    // Save to SQLite
    await DatabaseHelper.instance.saveResult(result);

    // Update Profile XP & Preparedness
    final profile = await DatabaseHelper.instance.getProfileById(profileId);
    if (profile != null) {
      final newXp = profile.xp + totalXpEarned;
      final newLevel = (newXp ~/ 100) + 1;
      // Preparedness score weighted average
      final newPreparedness = ((profile.preparednessScore * 0.7) + (overallScore * 0.3)).round().clamp(0, 100);

      final updatedProfile = profile.copyWith(
        xp: newXp,
        level: newLevel,
        preparednessScore: newPreparedness,
        lastActiveAt: DateTime.now(),
      );
      await DatabaseHelper.instance.saveProfile(updatedProfile);
    }

    // Check & Unlock Badges
    await _checkBadgeUnlocks(profileId, overallScore, avgSpeed, _currentScenario!.categoryId);

    notifyListeners();
  }

  Map<String, String> _generateFeedback(int overall, int safety, int speed, String catId) {
    String strengthsAr = '';
    String strengthsEn = '';
    String improvementsAr = '';
    String improvementsEn = '';
    String adviceAr = '';
    String adviceEn = '';

    if (safety >= 80) {
      strengthsAr = 'التزام عالٍ بقواعد السلامة وتجنب المخاطر القاتلة.';
      strengthsEn = 'High adherence to safety rules and avoidance of fatal risks.';
    } else {
      strengthsAr = 'المحاولة الجادة والرغبة في التصرف السريع.';
      strengthsEn = 'Determined attempt and intention to act promptly.';
    }

    if (speed >= 75) {
      strengthsAr += ' سرعة بديهة واستجابة فورية بدون تردد.';
      strengthsEn += ' Quick reflexes and prompt response without hesitation.';
    }

    if (safety < 70) {
      improvementsAr = 'الحذر من التسرع في اتخاذ خيارات تبدو أسرع لكنها تعرضك للمحاصرة أو الانفجار.';
      improvementsEn = 'Beware of hasty shortcuts that risk entrapment or explosive hazards.';
    } else if (speed < 60) {
      improvementsAr = 'تحسين سرعة اتخاذ القرار لتوفير ثوانٍ حاسمة أثناء الطوارئ.';
      improvementsEn = 'Improve decision latency to save critical seconds during emergencies.';
    } else {
      improvementsAr = 'مواصلة التدريب العملي لتثبيت ردود الأفعال التلقائية في الذاكرة.';
      improvementsEn = 'Continue scenario practice to engrain automatic life-saving reflexes.';
    }

    switch (catId) {
      case 'fire':
        adviceAr = 'تذكر دائمًا: النزول عبر السلالم، الزحف تحت الدخان، وعدم استخدام المصاعد نهائيًا.';
        adviceEn = 'Always remember: Take the stairs, crawl under smoke, never use elevators.';
        break;
      case 'flood':
        adviceAr = 'قاعدة السيول الذهبية: لا تجازف بقطع الأودية، 30 سم من الماء الجاري تجرف أثقل المركبات.';
        adviceEn = 'Golden flood rule: Never cross flowing wadis; 30cm of moving water sweeps heavy vehicles.';
        break;
      case 'heat':
        adviceAr = 'التبريد الفوري بالماء الفاتر والكمادات ونقل المصاب للظل يمنع تلف خلايا الدماغ.';
        adviceEn = 'Immediate evaporative cooling and shaded airflow prevents permanent brain trauma.';
        break;
      case 'traffic':
        adviceAr = 'تأمين الموقع بالمثلث العاكس على بعد 100م يمنع حوادث الاصطدام الثانوي المميتة.';
        adviceEn = 'Securing the scene with a 100m warning triangle prevents fatal secondary pileups.';
        break;
      case 'home':
        adviceAr = 'عند شم رائحة الغاز: لا تلمس مفاتيح الكهرباء أو الشفاط، افتح النوافذ وأغلق المحبس.';
        adviceEn = 'On smelling gas: Never flip electric switches; ventilate naturally & shut the valve.';
        break;
      default:
        adviceAr = 'الهدوء وضبط النفس والتقيد بإرشادات الجهات الرسمية هو صمام الأمان الأول.';
        adviceEn = 'Calm composure and adherence to official safety guidelines is your greatest shield.';
    }

    return {
      'strengthsAr': strengthsAr,
      'strengthsEn': strengthsEn,
      'improvementsAr': improvementsAr,
      'improvementsEn': improvementsEn,
      'adviceAr': adviceAr,
      'adviceEn': adviceEn,
    };
  }

  Future<void> _checkBadgeUnlocks(String profileId, int score, int speed, String catId) async {
    // 1. First Simulation Badge
    await DatabaseHelper.instance.unlockBadge(profileId, 'b_first_sim');

    // 2. High Score Badges
    if (catId == 'fire' && score >= 80) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_fire_hero');
    }
    if (catId == 'flood' && score >= 80) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_flood_guard');
    }
    if (catId == 'home' && score >= 80) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_home_master');
    }
    if (catId == 'traffic' && score >= 80) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_road_protector');
    }
    if (catId == 'evacuation' && score >= 80) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_evacuation_pro');
    }

    if (speed >= 80 && score >= 75) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_fast_responder');
    }

    if (score >= 90) {
      await DatabaseHelper.instance.unlockBadge(profileId, 'b_ready_champion');
    }

    // Refresh unlocked badges
    final allBadges = await DatabaseHelper.instance.getBadgesForProfile(profileId);
    _newlyUnlockedBadges = allBadges.where((b) => b.isUnlocked).toList();
  }

  void reset() {
    _timer?.cancel();
    _currentScenario = null;
    _currentStepIndex = 0;
    _status = SimulationStatus.idle;
    _selectedOption = null;
    _chosenOptions.clear();
    _stepTimeSpent.clear();
    _lastResult = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
