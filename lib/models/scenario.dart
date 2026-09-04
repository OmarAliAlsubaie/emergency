import 'scenario_step.dart';

class Scenario {
  final String id;
  final String categoryId;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String difficulty; // 'مبتدئ' / 'Beginner', 'متوسط' / 'Intermediate', 'متقدم' / 'Advanced'
  final int timeLimitSeconds; // Default countdown per step e.g. 15s
  final String icon;
  final int colorHex;
  final List<ScenarioStep> steps;

  const Scenario({
    required this.id,
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    this.difficulty = 'متوسط',
    this.timeLimitSeconds = 15,
    required this.icon,
    required this.colorHex,
    this.steps = const [],
  });

  Scenario copyWith({
    String? id,
    String? categoryId,
    String? titleAr,
    String? titleEn,
    String? descriptionAr,
    String? descriptionEn,
    String? difficulty,
    int? timeLimitSeconds,
    String? icon,
    int? colorHex,
    List<ScenarioStep>? steps,
  }) {
    return Scenario(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      difficulty: difficulty ?? this.difficulty,
      timeLimitSeconds: timeLimitSeconds ?? this.timeLimitSeconds,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      steps: steps ?? this.steps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'difficulty': difficulty,
      'timeLimitSeconds': timeLimitSeconds,
      'icon': icon,
      'colorHex': colorHex,
    };
  }

  factory Scenario.fromMap(Map<String, dynamic> map, {List<ScenarioStep> steps = const []}) {
    return Scenario(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      titleAr: map['titleAr'] as String,
      titleEn: map['titleEn'] as String,
      descriptionAr: map['descriptionAr'] as String,
      descriptionEn: map['descriptionEn'] as String,
      difficulty: map['difficulty'] as String? ?? 'متوسط',
      timeLimitSeconds: map['timeLimitSeconds'] as int? ?? 15,
      icon: map['icon'] as String? ?? 'warning',
      colorHex: map['colorHex'] as int? ?? 0xFF006C35,
      steps: steps,
    );
  }
}
