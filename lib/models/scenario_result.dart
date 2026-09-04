class ScenarioResult {
  final String id;
  final String profileId;
  final String scenarioId;
  final String scenarioTitleAr;
  final String scenarioTitleEn;
  final String categoryId;
  final int overallScore; // 0 - 100
  final int decisionSpeedScore; // 0 - 100
  final int safetyScore; // 0 - 100
  final int knowledgeScore; // 0 - 100
  final int responseScore; // 0 - 100
  final int timeTakenSeconds;
  final int xpEarned;
  final String strengthsAr;
  final String strengthsEn;
  final String improvementsAr;
  final String improvementsEn;
  final String adviceAr;
  final String adviceEn;
  final DateTime completedAt;

  const ScenarioResult({
    required this.id,
    required this.profileId,
    required this.scenarioId,
    required this.scenarioTitleAr,
    required this.scenarioTitleEn,
    required this.categoryId,
    required this.overallScore,
    required this.decisionSpeedScore,
    required this.safetyScore,
    required this.knowledgeScore,
    required this.responseScore,
    required this.timeTakenSeconds,
    required this.xpEarned,
    required this.strengthsAr,
    required this.strengthsEn,
    required this.improvementsAr,
    required this.improvementsEn,
    required this.adviceAr,
    required this.adviceEn,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'profileId': profileId,
      'scenarioId': scenarioId,
      'scenarioTitleAr': scenarioTitleAr,
      'scenarioTitleEn': scenarioTitleEn,
      'categoryId': categoryId,
      'overallScore': overallScore,
      'decisionSpeedScore': decisionSpeedScore,
      'safetyScore': safetyScore,
      'knowledgeScore': knowledgeScore,
      'responseScore': responseScore,
      'timeTakenSeconds': timeTakenSeconds,
      'xpEarned': xpEarned,
      'strengthsAr': strengthsAr,
      'strengthsEn': strengthsEn,
      'improvementsAr': improvementsAr,
      'improvementsEn': improvementsEn,
      'adviceAr': adviceAr,
      'adviceEn': adviceEn,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory ScenarioResult.fromMap(Map<String, dynamic> map) {
    return ScenarioResult(
      id: map['id'] as String,
      profileId: map['profileId'] as String,
      scenarioId: map['scenarioId'] as String,
      scenarioTitleAr: map['scenarioTitleAr'] as String? ?? '',
      scenarioTitleEn: map['scenarioTitleEn'] as String? ?? '',
      categoryId: map['categoryId'] as String? ?? '',
      overallScore: map['overallScore'] as int? ?? 0,
      decisionSpeedScore: map['decisionSpeedScore'] as int? ?? 0,
      safetyScore: map['safetyScore'] as int? ?? 0,
      knowledgeScore: map['knowledgeScore'] as int? ?? 0,
      responseScore: map['responseScore'] as int? ?? 0,
      timeTakenSeconds: map['timeTakenSeconds'] as int? ?? 0,
      xpEarned: map['xpEarned'] as int? ?? 0,
      strengthsAr: map['strengthsAr'] as String? ?? '',
      strengthsEn: map['strengthsEn'] as String? ?? '',
      improvementsAr: map['improvementsAr'] as String? ?? '',
      improvementsEn: map['improvementsEn'] as String? ?? '',
      adviceAr: map['adviceAr'] as String? ?? '',
      adviceEn: map['adviceEn'] as String? ?? '',
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
