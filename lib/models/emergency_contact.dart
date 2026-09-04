class EmergencyContact {
  final String id;
  final String nameAr;
  final String nameEn;
  final String number;
  final String icon;
  final String descriptionAr;
  final String descriptionEn;
  final int priority;
  final bool isOfficial;

  const EmergencyContact({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.number,
    required this.icon,
    required this.descriptionAr,
    required this.descriptionEn,
    this.priority = 1,
    this.isOfficial = true,
  });

  EmergencyContact copyWith({
    String? id,
    String? nameAr,
    String? nameEn,
    String? number,
    String? icon,
    String? descriptionAr,
    String? descriptionEn,
    int? priority,
    bool? isOfficial,
  }) {
    return EmergencyContact(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      number: number ?? this.number,
      icon: icon ?? this.icon,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      priority: priority ?? this.priority,
      isOfficial: isOfficial ?? this.isOfficial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'number': number,
      'icon': icon,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'priority': priority,
      'isOfficial': isOfficial ? 1 : 0,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      id: map['id'] as String,
      nameAr: map['nameAr'] as String,
      nameEn: map['nameEn'] as String,
      number: map['number'] as String,
      icon: map['icon'] as String? ?? 'phone',
      descriptionAr: map['descriptionAr'] as String? ?? '',
      descriptionEn: map['descriptionEn'] as String? ?? '',
      priority: map['priority'] as int? ?? 1,
      isOfficial: (map['isOfficial'] is int) ? (map['isOfficial'] == 1) : (map['isOfficial'] == true),
    );
  }
}
