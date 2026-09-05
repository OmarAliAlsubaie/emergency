import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../../models/category.dart';
import '../../models/scenario.dart';
import '../../models/scenario_step.dart';
import '../../models/scenario_option.dart';
import '../../models/scenario_result.dart';
import '../../models/badge.dart';
import '../../models/knowledge_article.dart';
import '../../models/emergency_contact.dart';
import '../../models/user_profile.dart';
import 'initial_seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('saudi_ready_offline.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWebNoWebWorker;
      return await openDatabase(
        inMemoryDatabasePath,
        version: 3,
        onCreate: _createDB,
        onOpen: (db) async {
          await _seedDatabase(db);
        },
      );
    }

    // Platform-specific FFI initialization for Windows, Linux, macOS
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final docDir = await getApplicationDocumentsDirectory();
      path = join(docDir.path, 'SaudiReady', filePath);
      final dir = Directory(dirname(path));
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
    }

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await _seedDatabase(db);
      },
      onOpen: (db) async {
        await _seedDatabase(db);
      },
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Categories
    await db.execute('''
      CREATE TABLE categories (
        id TEXT PRIMARY KEY,
        titleAr TEXT NOT NULL,
        titleEn TEXT NOT NULL,
        descriptionAr TEXT NOT NULL,
        descriptionEn TEXT NOT NULL,
        icon TEXT NOT NULL,
        colorHex INTEGER NOT NULL
      )
    ''');

    // 2. User Profiles
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        avatar TEXT NOT NULL,
        xp INTEGER NOT NULL DEFAULT 0,
        level INTEGER NOT NULL DEFAULT 1,
        preparednessScore INTEGER NOT NULL DEFAULT 50,
        createdAt TEXT NOT NULL,
        lastActiveAt TEXT NOT NULL
      )
    ''');

    // 3. Scenarios
    await db.execute('''
      CREATE TABLE scenarios (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        titleAr TEXT NOT NULL,
        titleEn TEXT NOT NULL,
        descriptionAr TEXT NOT NULL,
        descriptionEn TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        timeLimitSeconds INTEGER NOT NULL DEFAULT 30,
        icon TEXT NOT NULL,
        colorHex INTEGER NOT NULL
      )
    ''');

    // 4. Scenario Steps
    await db.execute('''
      CREATE TABLE scenario_steps (
        id TEXT PRIMARY KEY,
        scenarioId TEXT NOT NULL,
        stepOrder INTEGER NOT NULL,
        situationAr TEXT NOT NULL,
        situationEn TEXT NOT NULL,
        hintAr TEXT,
        hintEn TEXT,
        visualTheme TEXT NOT NULL
      )
    ''');

    // 5. Scenario Options
    await db.execute('''
      CREATE TABLE scenario_options (
        id TEXT PRIMARY KEY,
        stepId TEXT NOT NULL,
        textAr TEXT NOT NULL,
        textEn TEXT NOT NULL,
        isSafe INTEGER NOT NULL,
        safetyScore INTEGER NOT NULL,
        speedScore INTEGER NOT NULL,
        explanationAr TEXT NOT NULL,
        explanationEn TEXT NOT NULL,
        outcomeSummaryAr TEXT,
        outcomeSummaryEn TEXT,
        xpReward INTEGER NOT NULL DEFAULT 10
      )
    ''');

    // 6. Scenario Results (History)
    await db.execute('''
      CREATE TABLE scenario_results (
        id TEXT PRIMARY KEY,
        profileId TEXT NOT NULL,
        scenarioId TEXT NOT NULL,
        scenarioTitleAr TEXT NOT NULL,
        scenarioTitleEn TEXT NOT NULL,
        categoryId TEXT NOT NULL,
        overallScore INTEGER NOT NULL,
        decisionSpeedScore INTEGER NOT NULL,
        safetyScore INTEGER NOT NULL,
        knowledgeScore INTEGER NOT NULL,
        responseScore INTEGER NOT NULL,
        timeTakenSeconds INTEGER NOT NULL,
        xpEarned INTEGER NOT NULL,
        strengthsAr TEXT NOT NULL,
        strengthsEn TEXT NOT NULL,
        improvementsAr TEXT NOT NULL,
        improvementsEn TEXT NOT NULL,
        adviceAr TEXT NOT NULL,
        adviceEn TEXT NOT NULL,
        completedAt TEXT NOT NULL
      )
    ''');

    // 7. Badges
    await db.execute('''
      CREATE TABLE badges (
        id TEXT PRIMARY KEY,
        code TEXT NOT NULL UNIQUE,
        titleAr TEXT NOT NULL,
        titleEn TEXT NOT NULL,
        descriptionAr TEXT NOT NULL,
        descriptionEn TEXT NOT NULL,
        icon TEXT NOT NULL,
        requiredXp INTEGER NOT NULL,
        categoryId TEXT NOT NULL
      )
    ''');

    // 8. Profile Unlocked Badges
    await db.execute('''
      CREATE TABLE profile_badges (
        profileId TEXT NOT NULL,
        badgeId TEXT NOT NULL,
        unlockedAt TEXT NOT NULL,
        PRIMARY KEY (profileId, badgeId)
      )
    ''');

    // 9. Knowledge Articles
    await db.execute('''
      CREATE TABLE knowledge_articles (
        id TEXT PRIMARY KEY,
        categoryId TEXT NOT NULL,
        titleAr TEXT NOT NULL,
        titleEn TEXT NOT NULL,
        summaryAr TEXT NOT NULL,
        summaryEn TEXT NOT NULL,
        contentAr TEXT NOT NULL,
        contentEn TEXT NOT NULL,
        icon TEXT NOT NULL,
        stepsAr TEXT NOT NULL,
        stepsEn TEXT NOT NULL,
        doListAr TEXT NOT NULL,
        doListEn TEXT NOT NULL,
        dontListAr TEXT NOT NULL,
        dontListEn TEXT NOT NULL,
        readingTimeMinutes INTEGER NOT NULL DEFAULT 3
      )
    ''');

    // 10. Article Bookmarks
    await db.execute('''
      CREATE TABLE article_bookmarks (
        profileId TEXT NOT NULL,
        articleId TEXT NOT NULL,
        bookmarkedAt TEXT NOT NULL,
        PRIMARY KEY (profileId, articleId)
      )
    ''');

    // 11. Emergency Contacts
    await db.execute('''
      CREATE TABLE emergency_contacts (
        id TEXT PRIMARY KEY,
        nameAr TEXT NOT NULL,
        nameEn TEXT NOT NULL,
        number TEXT NOT NULL,
        icon TEXT NOT NULL,
        descriptionAr TEXT NOT NULL,
        descriptionEn TEXT NOT NULL,
        priority INTEGER NOT NULL DEFAULT 1,
        isOfficial INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Seed Initial Offline Data
    await _seedDatabase(db);
  }

  Future<void> _seedDatabase(Database db) async {
    final batch = db.batch();

    // 1. Categories
    for (final cat in InitialSeedData.categories) {
      batch.insert('categories', cat.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 2. Default Profiles
    for (final profile in InitialSeedData.defaultProfiles) {
      batch.insert('user_profiles', profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 3. Emergency Contacts
    for (final contact in InitialSeedData.emergencyContacts) {
      batch.insert('emergency_contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 4. Badges
    for (final badge in InitialSeedData.defaultBadges) {
      batch.insert('badges', badge.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // 5. Scenarios, Steps, Options
    for (final scenario in InitialSeedData.initialScenarios) {
      batch.insert('scenarios', scenario.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

      for (final step in scenario.steps) {
        batch.insert('scenario_steps', step.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

        for (final opt in step.options) {
          batch.insert('scenario_options', opt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    }

    // 6. Knowledge Articles
    for (final art in InitialSeedData.knowledgeArticles) {
      batch.insert('knowledge_articles', art.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }

    batch.rawUpdate('UPDATE scenarios SET timeLimitSeconds = 30;');

    await batch.commit(noResult: true);
  }

  // ==================== QUERY & CRUD OPERATIONS ====================

  // --- Profiles ---
  Future<List<UserProfile>> getAllProfiles() async {
    final db = await instance.database;
    final maps = await db.query('user_profiles', orderBy: 'createdAt ASC');
    return maps.map((e) => UserProfile.fromMap(e)).toList();
  }

  Future<UserProfile?> getProfileById(String id) async {
    final db = await instance.database;
    final maps = await db.query('user_profiles', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return UserProfile.fromMap(maps.first);
    }
    return null;
  }

  Future<void> saveProfile(UserProfile profile) async {
    final db = await instance.database;
    await db.insert('user_profiles', profile.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteProfile(String id) async {
    final db = await instance.database;
    await db.delete('user_profiles', where: 'id = ?', whereArgs: [id]);
    await db.delete('scenario_results', where: 'profileId = ?', whereArgs: [id]);
    await db.delete('profile_badges', where: 'profileId = ?', whereArgs: [id]);
  }

  // --- Categories ---
  Future<List<SimulationCategory>> getAllCategories() async {
    final db = await instance.database;
    final maps = await db.query('categories');
    return maps.map((e) => SimulationCategory.fromMap(e)).toList();
  }

  // --- Scenarios ---
  Future<List<Scenario>> getAllScenarios() async {
    final db = await instance.database;
    final scMaps = await db.query('scenarios');
    final List<Scenario> scenarios = [];

    for (final map in scMaps) {
      final scId = map['id'] as String;
      final steps = await getStepsForScenario(scId);
      scenarios.add(Scenario.fromMap(map, steps: steps));
    }
    return scenarios;
  }

  Future<List<Scenario>> getScenariosByCategory(String categoryId) async {
    final db = await instance.database;
    final scMaps = await db.query('scenarios', where: 'categoryId = ?', whereArgs: [categoryId]);
    final List<Scenario> scenarios = [];

    for (final map in scMaps) {
      final scId = map['id'] as String;
      final steps = await getStepsForScenario(scId);
      scenarios.add(Scenario.fromMap(map, steps: steps));
    }
    return scenarios;
  }

  Future<Scenario?> getScenarioById(String id) async {
    final db = await instance.database;
    final maps = await db.query('scenarios', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    final steps = await getStepsForScenario(id);
    return Scenario.fromMap(maps.first, steps: steps);
  }

  Future<List<ScenarioStep>> getStepsForScenario(String scenarioId) async {
    final db = await instance.database;
    final stepMaps = await db.query(
      'scenario_steps',
      where: 'scenarioId = ?',
      whereArgs: [scenarioId],
      orderBy: 'stepOrder ASC',
    );

    final List<ScenarioStep> steps = [];
    for (final stepMap in stepMaps) {
      final stepId = stepMap['id'] as String;
      final optMaps = await db.query(
        'scenario_options',
        where: 'stepId = ?',
        whereArgs: [stepId],
      );
      final options = optMaps.map((e) => ScenarioOption.fromMap(e)).toList();
      steps.add(ScenarioStep.fromMap(stepMap, options: options));
    }
    return steps;
  }

  Future<void> saveScenario(Scenario scenario) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      await txn.insert('scenarios', scenario.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

      // Clean existing steps & options for this scenario
      final existingSteps = await txn.query('scenario_steps', where: 'scenarioId = ?', whereArgs: [scenario.id]);
      for (final st in existingSteps) {
        await txn.delete('scenario_options', where: 'stepId = ?', whereArgs: [st['id']]);
      }
      await txn.delete('scenario_steps', where: 'scenarioId = ?', whereArgs: [scenario.id]);

      // Re-insert steps and options
      for (final step in scenario.steps) {
        await txn.insert('scenario_steps', step.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        for (final opt in step.options) {
          await txn.insert('scenario_options', opt.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
        }
      }
    });
  }

  Future<void> deleteScenario(String scenarioId) async {
    final db = await instance.database;
    await db.transaction((txn) async {
      final existingSteps = await txn.query('scenario_steps', where: 'scenarioId = ?', whereArgs: [scenarioId]);
      for (final st in existingSteps) {
        await txn.delete('scenario_options', where: 'stepId = ?', whereArgs: [st['id']]);
      }
      await txn.delete('scenario_steps', where: 'scenarioId = ?', whereArgs: [scenarioId]);
      await txn.delete('scenarios', where: 'id = ?', whereArgs: [scenarioId]);
    });
  }

  // --- Scenario Results (History) ---
  Future<void> saveResult(ScenarioResult result) async {
    final db = await instance.database;
    await db.insert('scenario_results', result.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ScenarioResult>> getResultsForProfile(String profileId) async {
    final db = await instance.database;
    final maps = await db.query(
      'scenario_results',
      where: 'profileId = ?',
      whereArgs: [profileId],
      orderBy: 'completedAt DESC',
    );
    return maps.map((e) => ScenarioResult.fromMap(e)).toList();
  }

  Future<ScenarioResult?> getLatestResultForProfile(String profileId) async {
    final db = await instance.database;
    final maps = await db.query(
      'scenario_results',
      where: 'profileId = ?',
      whereArgs: [profileId],
      orderBy: 'completedAt DESC',
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return ScenarioResult.fromMap(maps.first);
    }
    return null;
  }

  // --- Badges ---
  Future<List<SafetyBadge>> getBadgesForProfile(String profileId) async {
    final db = await instance.database;
    final allBadgesMaps = await db.query('badges');
    final unlockedMaps = await db.query(
      'profile_badges',
      where: 'profileId = ?',
      whereArgs: [profileId],
    );

    final unlockedMap = <String, DateTime>{};
    for (final row in unlockedMaps) {
      final bId = row['badgeId'] as String;
      final dt = DateTime.tryParse(row['unlockedAt'] as String) ?? DateTime.now();
      unlockedMap[bId] = dt;
    }

    return allBadgesMaps.map((b) {
      final id = b['id'] as String;
      final isUnlocked = unlockedMap.containsKey(id);
      return SafetyBadge.fromMap(b, isUnlocked: isUnlocked, unlockedAt: unlockedMap[id]);
    }).toList();
  }

  Future<void> unlockBadge(String profileId, String badgeId) async {
    final db = await instance.database;
    await db.insert(
      'profile_badges',
      {
        'profileId': profileId,
        'badgeId': badgeId,
        'unlockedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // --- Knowledge Articles ---
  Future<List<KnowledgeArticle>> getArticles({String? categoryId, String? profileId}) async {
    final db = await instance.database;
    List<Map<String, dynamic>> maps;
    if (categoryId != null && categoryId.isNotEmpty && categoryId != 'all') {
      maps = await db.query('knowledge_articles', where: 'categoryId = ?', whereArgs: [categoryId]);
    } else {
      maps = await db.query('knowledge_articles');
    }

    Set<String> bookmarkedIds = {};
    if (profileId != null) {
      final bMaps = await db.query('article_bookmarks', where: 'profileId = ?', whereArgs: [profileId]);
      bookmarkedIds = bMaps.map((e) => e['articleId'] as String).toSet();
    }

    return maps.map((e) {
      final id = e['id'] as String;
      return KnowledgeArticle.fromMap(e, isBookmarked: bookmarkedIds.contains(id));
    }).toList();
  }

  Future<void> toggleArticleBookmark(String profileId, String articleId, bool isBookmarked) async {
    final db = await instance.database;
    if (isBookmarked) {
      await db.insert(
        'article_bookmarks',
        {
          'profileId': profileId,
          'articleId': articleId,
          'bookmarkedAt': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      await db.delete(
        'article_bookmarks',
        where: 'profileId = ? AND articleId = ?',
        whereArgs: [profileId, articleId],
      );
    }
  }

  Future<void> saveKnowledgeArticle(KnowledgeArticle article) async {
    final db = await instance.database;
    await db.insert('knowledge_articles', article.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteKnowledgeArticle(String id) async {
    final db = await instance.database;
    await db.delete('knowledge_articles', where: 'id = ?', whereArgs: [id]);
  }

  // --- Emergency Contacts ---
  Future<List<EmergencyContact>> getAllEmergencyContacts() async {
    final db = await instance.database;
    final maps = await db.query('emergency_contacts', orderBy: 'priority ASC');
    return maps.map((e) => EmergencyContact.fromMap(e)).toList();
  }

  Future<void> saveEmergencyContact(EmergencyContact contact) async {
    final db = await instance.database;
    await db.insert('emergency_contacts', contact.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteEmergencyContact(String id) async {
    final db = await instance.database;
    await db.delete('emergency_contacts', where: 'id = ?', whereArgs: [id]);
  }

  // --- Reset / Re-seed Database ---
  Future<void> resetToFactoryDefaults() async {
    final db = await instance.database;
    await db.delete('scenario_options');
    await db.delete('scenario_steps');
    await db.delete('scenarios');
    await db.delete('categories');
    await db.delete('knowledge_articles');
    await db.delete('emergency_contacts');
    await db.delete('badges');
    await db.delete('profile_badges');
    await db.delete('article_bookmarks');
    await db.delete('scenario_results');
    await db.delete('user_profiles');

    await _seedDatabase(db);
  }
}
