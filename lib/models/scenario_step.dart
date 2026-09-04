import 'scenario_option.dart';

class ScenarioStep {
  final String id;
  final String scenarioId;
  final int stepOrder;
  final String situationAr;
  final String situationEn;
  final String hintAr;
  final String hintEn;
  final String visualTheme; // 'fire', 'flood', 'heat', 'car', 'home', 'evacuation', 'electric', 'firstaid'
  final List<ScenarioOption> options;

  const ScenarioStep({
    required this.id,
    required this.scenarioId,
    required this.stepOrder,
    required this.situationAr,
    required this.situationEn,
    this.hintAr = '',
    this.hintEn = '',
    this.visualTheme = 'emergency',
    this.options = const [],
  });

  ScenarioStep copyWith({
    String? id,
    String? scenarioId,
    int? stepOrder,
    String? situationAr,
    String? situationEn,
    String? hintAr,
    String? hintEn,
    String? visualTheme,
    List<ScenarioOption>? options,
  }) {
    return ScenarioStep(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      stepOrder: stepOrder ?? this.stepOrder,
      situationAr: situationAr ?? this.situationAr,
      situationEn: situationEn ?? this.situationEn,
      hintAr: hintAr ?? this.hintAr,
      hintEn: hintEn ?? this.hintEn,
      visualTheme: visualTheme ?? this.visualTheme,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scenarioId': scenarioId,
      'stepOrder': stepOrder,
      'situationAr': situationAr,
      'situationEn': situationEn,
      'hintAr': hintAr,
      'hintEn': hintEn,
      'visualTheme': visualTheme,
    };
  }

  factory ScenarioStep.fromMap(Map<String, dynamic> map, {List<ScenarioOption> options = const []}) {
    return ScenarioStep(
      id: map['id'] as String,
      scenarioId: map['scenarioId'] as String,
      stepOrder: map['stepOrder'] as int? ?? 1,
      situationAr: map['situationAr'] as String,
      situationEn: map['situationEn'] as String,
      hintAr: map['hintAr'] as String? ?? '',
      hintEn: map['hintEn'] as String? ?? '',
      visualTheme: map['visualTheme'] as String? ?? 'emergency',
      options: options,
    );
  }
}
