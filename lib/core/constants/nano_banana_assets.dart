class NanoBananaAssets {
  // Official Saudi Emergency 911 Ready Logo
  static const String logo = 'assets/images/saudi_shield_logo.png';

  // Avatars (High-Quality Saudi & Rescue Characters)
  static const String nanoBoy = 'assets/images/nano_boy.jpeg';
  static const String nanoGirl = 'assets/images/nano_girl.jpeg';
  static const String nanoResponder = 'assets/images/nano_responder.jpeg';
  static const String officerNoBg = 'assets/images/Emergency_officer-no-bac.png';
  static const String avatarFather = 'assets/images/avatar_father.jpeg';
  static const String avatarMother = 'assets/images/avatar_mother.jpeg';
  static const String xpBadge =
      'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?w=600&auto=format&fit=crop&q=80';

  // Specific Safety Categories & Challenges
  static const String catFire = 'assets/images/fire_safety.jpeg';
  static const String catFlood = 'assets/images/flood_safety.jpeg';
  static const String catHeat = 'assets/images/heat_safety.jpeg';
  static const String catTraffic = 'assets/images/traffic_safety.jpeg';
  static const String catHome = 'assets/images/home_safety.jpeg';
  static const String catElectric = 'assets/images/electrical_safety.jpeg';
  static const String catEvacuation = 'assets/images/evacuation_safety.jpeg';
  static const String catEmergencyKit = 'assets/images/emergency_kit.jpeg';
  static const String catDesert = 'assets/images/desert_safety.jpeg';
  static const String catCyber = 'assets/images/cyber_safety.jpeg';

  // Scenario Highlights
  static const String scFireEvacuation = catFire;
  static const String scFlashFlood = catFlood;
  static const String scHeatSun = catHeat;
  static const String scTrafficCrash = catTraffic;
  static const String scGasLeak = catHome;
  static const String scDesertSafety = catDesert;
  static const String scCyberSafety = catCyber;

  static String getUrlForAsset(String assetPathOrName) {
    if (assetPathOrName.isEmpty) return nanoBoy;

    // Direct exact matches with existing asset paths
    if (assetPathOrName == logo ||
        assetPathOrName == nanoBoy ||
        assetPathOrName == nanoGirl ||
        assetPathOrName == nanoResponder ||
        assetPathOrName == officerNoBg ||
        assetPathOrName == avatarFather ||
        assetPathOrName == avatarMother ||
        assetPathOrName == catFire ||
        assetPathOrName == catFlood ||
        assetPathOrName == catHeat ||
        assetPathOrName == catTraffic ||
        assetPathOrName == catHome ||
        assetPathOrName == catElectric ||
        assetPathOrName == catEvacuation ||
        assetPathOrName == catEmergencyKit ||
        assetPathOrName == catDesert ||
        assetPathOrName == catCyber) {
      return assetPathOrName;
    }

    final lower = assetPathOrName.toLowerCase();

    // Map legacy missing/broken asset paths or keyword searches
    if (lower.contains('no-bac') || lower.contains('no_bg') || lower.contains('nobg')) return officerNoBg;
    if (lower.contains('girl')) return nanoGirl;
    if (lower.contains('responder') || lower.contains('officer')) return nanoResponder;
    if (lower.contains('father')) return avatarFather;
    if (lower.contains('mother')) return avatarMother;
    if (lower.contains('boy')) return nanoBoy;
    if (lower.contains('logo') || lower.contains('shield') || lower.contains('saudi')) return logo;
    if (lower.contains('fire')) return catFire;
    if (lower.contains('flood') || lower.contains('wadi')) return catFlood;
    if (lower.contains('heat') || lower.contains('sun')) return catHeat;
    if (lower.contains('traffic') || lower.contains('road') || lower.contains('car')) return catTraffic;
    if (lower.contains('home') || lower.contains('gas') || lower.contains('detector')) return catHome;
    if (lower.contains('electric') || lower.contains('breaker') || lower.contains('short')) return catElectric;
    if (lower.contains('evac') || lower.contains('exit') || lower.contains('crowd')) return catEvacuation;
    if (lower.contains('kit') || lower.contains('bag') || lower.contains('backpack')) return catEmergencyKit;
    if (lower.contains('desert') || lower.contains('tire')) return catDesert;
    if (lower.contains('cyber') || lower.contains('otp')) return catCyber;
    if (lower.contains('badge') || lower.contains('xp')) return xpBadge;

    if (assetPathOrName.startsWith('http://') || assetPathOrName.startsWith('https://')) {
      return assetPathOrName;
    }

    return nanoBoy;
  }
}
