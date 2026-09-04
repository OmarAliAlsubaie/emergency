class KnowledgeArticle {
  final String id;
  final String categoryId;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final String contentAr;
  final String contentEn;
  final String icon;
  final List<String> stepsAr;
  final List<String> stepsEn;
  final List<String> doListAr;
  final List<String> doListEn;
  final List<String> dontListAr;
  final List<String> dontListEn;
  final bool isBookmarked;
  final int readingTimeMinutes;

  const KnowledgeArticle({
    required this.id,
    required this.categoryId,
    required this.titleAr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryEn,
    required this.contentAr,
    required this.contentEn,
    required this.icon,
    this.stepsAr = const [],
    this.stepsEn = const [],
    this.doListAr = const [],
    this.doListEn = const [],
    this.dontListAr = const [],
    this.dontListEn = const [],
    this.isBookmarked = false,
    this.readingTimeMinutes = 3,
  });

  KnowledgeArticle copyWith({
    String? id,
    String? categoryId,
    String? titleAr,
    String? titleEn,
    String? summaryAr,
    String? summaryEn,
    String? contentAr,
    String? contentEn,
    String? icon,
    List<String>? stepsAr,
    List<String>? stepsEn,
    List<String>? doListAr,
    List<String>? doListEn,
    List<String>? dontListAr,
    List<String>? dontListEn,
    bool? isBookmarked,
    int? readingTimeMinutes,
  }) {
    return KnowledgeArticle(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      summaryAr: summaryAr ?? this.summaryAr,
      summaryEn: summaryEn ?? this.summaryEn,
      contentAr: contentAr ?? this.contentAr,
      contentEn: contentEn ?? this.contentEn,
      icon: icon ?? this.icon,
      stepsAr: stepsAr ?? this.stepsAr,
      stepsEn: stepsEn ?? this.stepsEn,
      doListAr: doListAr ?? this.doListAr,
      doListEn: doListEn ?? this.doListEn,
      dontListAr: dontListAr ?? this.dontListAr,
      dontListEn: dontListEn ?? this.dontListEn,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      readingTimeMinutes: readingTimeMinutes ?? this.readingTimeMinutes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'titleAr': titleAr,
      'titleEn': titleEn,
      'summaryAr': summaryAr,
      'summaryEn': summaryEn,
      'contentAr': contentAr,
      'contentEn': contentEn,
      'icon': icon,
      'stepsAr': stepsAr.join('|||'),
      'stepsEn': stepsEn.join('|||'),
      'doListAr': doListAr.join('|||'),
      'doListEn': doListEn.join('|||'),
      'dontListAr': dontListAr.join('|||'),
      'dontListEn': dontListEn.join('|||'),
      'readingTimeMinutes': readingTimeMinutes,
    };
  }

  factory KnowledgeArticle.fromMap(Map<String, dynamic> map, {bool isBookmarked = false}) {
    return KnowledgeArticle(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      titleAr: map['titleAr'] as String,
      titleEn: map['titleEn'] as String,
      summaryAr: map['summaryAr'] as String,
      summaryEn: map['summaryEn'] as String,
      contentAr: map['contentAr'] as String,
      contentEn: map['contentEn'] as String,
      icon: map['icon'] as String? ?? 'menu_book',
      stepsAr: (map['stepsAr'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      stepsEn: (map['stepsEn'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      doListAr: (map['doListAr'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      doListEn: (map['doListEn'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      dontListAr: (map['dontListAr'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      dontListEn: (map['dontListEn'] as String?)?.split('|||').where((s) => s.isNotEmpty).toList() ?? [],
      isBookmarked: isBookmarked,
      readingTimeMinutes: map['readingTimeMinutes'] as int? ?? 3,
    );
  }
}
