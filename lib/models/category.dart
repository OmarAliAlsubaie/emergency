class SimulationCategory {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String icon;
  final int colorHex;

  const SimulationCategory({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    required this.colorHex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'icon': icon,
      'colorHex': colorHex,
    };
  }

  factory SimulationCategory.fromMap(Map<String, dynamic> map) {
    return SimulationCategory(
      id: map['id'] as String,
      titleAr: map['titleAr'] as String,
      titleEn: map['titleEn'] as String,
      descriptionAr: map['descriptionAr'] as String,
      descriptionEn: map['descriptionEn'] as String,
      icon: map['icon'] as String,
      colorHex: map['colorHex'] as int,
    );
  }
}
