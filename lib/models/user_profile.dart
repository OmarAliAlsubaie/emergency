class UserProfile {
  final String id;
  final String name;
  final String role; // 'الأب', 'الأم', 'الابن', 'الابنة', 'فرد العائلة'
  final String avatar; // Icon name or avatar key
  final int xp;
  final int level;
  final int preparednessScore;
  final DateTime createdAt;
  final DateTime lastActiveAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.role,
    this.avatar = 'shield',
    this.xp = 0,
    this.level = 1,
    this.preparednessScore = 50,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastActiveAt = lastActiveAt ?? DateTime.now();

  String get levelTitleAr {
    if (level >= 10) return 'بطل الجاهزية الوطني';
    if (level >= 7) return 'خبير إدارة الطوارئ';
    if (level >= 5) return 'منقذ متقدم';
    if (level >= 3) return 'مستجيب مدرب';
    return 'مبتدئ واعد';
  }

  String get levelTitleEn {
    if (level >= 10) return 'National Readiness Champion';
    if (level >= 7) return 'Emergency Management Expert';
    if (level >= 5) return 'Advanced Rescuer';
    if (level >= 3) return 'Trained Responder';
    return 'Promising Beginner';
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? role,
    String? avatar,
    int? xp,
    int? level,
    int? preparednessScore,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      preparednessScore: preparednessScore ?? this.preparednessScore,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatar': avatar,
      'xp': xp,
      'level': level,
      'preparednessScore': preparednessScore,
      'createdAt': createdAt.toIso8601String(),
      'lastActiveAt': lastActiveAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      avatar: map['avatar'] as String? ?? 'shield',
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      preparednessScore: map['preparednessScore'] as int? ?? 50,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastActiveAt: map['lastActiveAt'] != null
          ? DateTime.tryParse(map['lastActiveAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
