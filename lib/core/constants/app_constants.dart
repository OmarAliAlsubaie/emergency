class AppConstants {
  static const String appNameAr = 'جاهز للطوارئ';
  static const String appNameEn = 'Emergency Ready';
  static const String appSubtitleAr = 'تعلم. تدرب. كن جاهزًا.';
  static const String appSubtitleEn = 'Learn. Train. Be Ready.';
  static const String appSloganAr = 'تعلم من خلال التجربة والمحاكاة، وليس القراءة فقط.';
  static const String appSloganEn = 'Learn through real interactive simulations, not just reading.';
  static const String appVersion = '1.0.0 (Offline Edition)';

  // Default Admin PIN for offline administration
  static const String defaultAdminPin = '1234';

  // XP Milestones
  static const int xpPerCorrectDecision = 25;
  static const int xpPerScenarioCompletion = 100;
  static const int xpForLevel2 = 100;
  static const int xpForLevel3 = 300;
  static const int xpForLevel4 = 600;
  static const int xpForLevel5 = 1000;
  static const int xpForLevel6 = 1500;
  static const int xpForLevel7 = 2200;
  static const int xpForLevel8 = 3000;
  static const int xpForLevel9 = 4000;
  static const int xpForLevel10 = 5500;

  static int calculateLevel(int xp) {
    if (xp >= xpForLevel10) return 10;
    if (xp >= xpForLevel9) return 9;
    if (xp >= xpForLevel8) return 8;
    if (xp >= xpForLevel7) return 7;
    if (xp >= xpForLevel6) return 6;
    if (xp >= xpForLevel5) return 5;
    if (xp >= xpForLevel4) return 4;
    if (xp >= xpForLevel3) return 3;
    if (xp >= xpForLevel2) return 2;
    return 1;
  }

  static double calculateLevelProgress(int xp) {
    final currentLevel = calculateLevel(xp);
    if (currentLevel >= 10) return 1.0;
    int currentLevelBase = 0;
    int nextLevelBase = xpForLevel2;

    switch (currentLevel) {
      case 1:
        currentLevelBase = 0;
        nextLevelBase = xpForLevel2;
        break;
      case 2:
        currentLevelBase = xpForLevel2;
        nextLevelBase = xpForLevel3;
        break;
      case 3:
        currentLevelBase = xpForLevel3;
        nextLevelBase = xpForLevel4;
        break;
      case 4:
        currentLevelBase = xpForLevel4;
        nextLevelBase = xpForLevel5;
        break;
      case 5:
        currentLevelBase = xpForLevel5;
        nextLevelBase = xpForLevel6;
        break;
      case 6:
        currentLevelBase = xpForLevel6;
        nextLevelBase = xpForLevel7;
        break;
      case 7:
        currentLevelBase = xpForLevel7;
        nextLevelBase = xpForLevel8;
        break;
      case 8:
        currentLevelBase = xpForLevel8;
        nextLevelBase = xpForLevel9;
        break;
      case 9:
        currentLevelBase = xpForLevel9;
        nextLevelBase = xpForLevel10;
        break;
    }

    final diff = nextLevelBase - currentLevelBase;
    if (diff <= 0) return 1.0;
    final progress = (xp - currentLevelBase) / diff;
    return progress.clamp(0.0, 1.0);
  }
}
