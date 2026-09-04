class SafetyBadge {
  final String id;
  final String code;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String icon;
  final int requiredXp;
  final String categoryId;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const SafetyBadge({
    required this.id,
    required this.code,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    this.requiredXp = 0,
    this.categoryId = 'general',
    this.isUnlocked = false,
    this.unlockedAt,
  });

  SafetyBadge copyWith({
    String? id,
    String? code,
    String? titleAr,
    String? titleEn,
    String? descriptionAr,
    String? descriptionEn,
    String? icon,
    int? requiredXp,
    String? categoryId,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return SafetyBadge(
      id: id ?? this.id,
      code: code ?? this.code,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      icon: icon ?? this.icon,
      requiredXp: requiredXp ?? this.requiredXp,
      categoryId: categoryId ?? this.categoryId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'icon': icon,
      'requiredXp': requiredXp,
      'categoryId': categoryId,
    };
  }

  factory SafetyBadge.fromMap(Map<String, dynamic> map, {bool isUnlocked = false, DateTime? unlockedAt}) {
    return SafetyBadge(
      id: map['id'] as String,
      code: map['code'] as String,
      titleAr: map['titleAr'] as String,
      titleEn: map['titleEn'] as String,
      descriptionAr: map['descriptionAr'] as String,
      descriptionEn: map['descriptionEn'] as String,
      icon: map['icon'] as String,
      requiredXp: map['requiredXp'] as int? ?? 0,
      categoryId: map['categoryId'] as String? ?? 'general',
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt,
    );
  }
}
