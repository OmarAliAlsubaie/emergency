class ScenarioOption {
  final String id;
  final String stepId;
  final String textAr;
  final String textEn;
  final bool isSafe; // true = Safe decision, false = Unsafe
  final int safetyScore; // 0 - 100
  final int speedScore; // base speed reward
  final String explanationAr;
  final String explanationEn;
  final String outcomeSummaryAr;
  final String outcomeSummaryEn;
  final int xpReward;

  const ScenarioOption({
    required this.id,
    required this.stepId,
    required this.textAr,
    required this.textEn,
    required this.isSafe,
    required this.safetyScore,
    required this.speedScore,
    required this.explanationAr,
    required this.explanationEn,
    required this.outcomeSummaryAr,
    required this.outcomeSummaryEn,
    required this.xpReward,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stepId': stepId,
      'textAr': textAr,
      'textEn': textEn,
      'isSafe': isSafe ? 1 : 0,
      'safetyScore': safetyScore,
      'speedScore': speedScore,
      'explanationAr': explanationAr,
      'explanationEn': explanationEn,
      'outcomeSummaryAr': outcomeSummaryAr,
      'outcomeSummaryEn': outcomeSummaryEn,
      'xpReward': xpReward,
    };
  }

  factory ScenarioOption.fromMap(Map<String, dynamic> map) {
    return ScenarioOption(
      id: map['id'] as String,
      stepId: map['stepId'] as String,
      textAr: map['textAr'] as String,
      textEn: map['textEn'] as String,
      isSafe: (map['isSafe'] is int) ? (map['isSafe'] == 1) : (map['isSafe'] == true),
      safetyScore: map['safetyScore'] as int? ?? 0,
      speedScore: map['speedScore'] as int? ?? 0,
      explanationAr: map['explanationAr'] as String,
      explanationEn: map['explanationEn'] as String,
      outcomeSummaryAr: map['outcomeSummaryAr'] as String? ?? '',
      outcomeSummaryEn: map['outcomeSummaryEn'] as String? ?? '',
      xpReward: map['xpReward'] as int? ?? 10,
    );
  }
}
