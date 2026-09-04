import 'package:flutter_test/flutter_test.dart';
import 'package:saudi_ready/core/constants/app_constants.dart';
import 'package:saudi_ready/core/database/initial_seed_data.dart';
import 'package:saudi_ready/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:saudi_ready/models/user_profile.dart';

void main() {
  group('AppConstants & Level Engine Tests', () {
    test('Calculates user levels correctly from XP', () {
      expect(AppConstants.calculateLevel(0), 1);
      expect(AppConstants.calculateLevel(99), 1);
      expect(AppConstants.calculateLevel(100), 2);
      expect(AppConstants.calculateLevel(299), 2);
      expect(AppConstants.calculateLevel(300), 3);
      expect(AppConstants.calculateLevel(1000), 5);
      expect(AppConstants.calculateLevel(5500), 10);
      expect(AppConstants.calculateLevel(10000), 10);
    });

    test('Calculates level progress accurately as double 0.0 to 1.0', () {
      expect(AppConstants.calculateLevelProgress(0), 0.0);
      expect(AppConstants.calculateLevelProgress(50), 0.5);
      expect(AppConstants.calculateLevelProgress(100), 0.0);
      expect(AppConstants.calculateLevelProgress(5500), 1.0);
    });
  });

  group('UserProfile Model Tests', () {
    test('Provides correct Arabic and English level titles', () {
      final beginner = UserProfile(id: '1', name: 'سعود', role: 'الابن', level: 1);
      expect(beginner.levelTitleAr, 'مبتدئ واعد');
      expect(beginner.levelTitleEn, 'Promising Beginner');

      final expert = UserProfile(id: '2', name: 'عبدالله', role: 'الأب', level: 8);
      expect(expert.levelTitleAr, 'خبير إدارة الطوارئ');
      expect(expert.levelTitleEn, 'Emergency Management Expert');

      final champion = UserProfile(id: '3', name: 'نورة', role: 'الأم', level: 10);
      expect(champion.levelTitleAr, 'بطل الجاهزية الوطني');
      expect(champion.levelTitleEn, 'National Readiness Champion');
    });

    test('Serialization to/from Map works identically', () {
      final original = UserProfile(
        id: 'test_p',
        name: 'فيصل',
        role: 'الابن',
        avatar: 'star',
        xp: 150,
        level: 2,
        preparednessScore: 85,
      );

      final map = original.toMap();
      final reconstructed = UserProfile.fromMap(map);

      expect(reconstructed.id, original.id);
      expect(reconstructed.name, original.name);
      expect(reconstructed.role, original.role);
      expect(reconstructed.avatar, original.avatar);
      expect(reconstructed.xp, original.xp);
      expect(reconstructed.level, original.level);
      expect(reconstructed.preparednessScore, original.preparednessScore);
    });
  });

  group('Initial Seed Data & Offline Content Tests', () {
    test('Contains all 8 required emergency categories', () {
      final categories = InitialSeedData.categories;
      expect(categories.length >= 8, true);
      final catIds = categories.map((c) => c.id).toSet();
      expect(catIds.contains('fire'), true);
      expect(catIds.contains('flood'), true);
      expect(catIds.contains('heat'), true);
      expect(catIds.contains('traffic'), true);
      expect(catIds.contains('home'), true);
      expect(catIds.contains('evacuation'), true);
      expect(catIds.contains('electric'), true);
      expect(catIds.contains('emergency_kit'), true);
    });

    test('Initial scenarios are complete with multiple steps and choices', () {
      final scenarios = InitialSeedData.initialScenarios;
      expect(scenarios.length >= 5, true);

      for (final sc in scenarios) {
        expect(sc.id.isNotEmpty, true);
        expect(sc.titleAr.isNotEmpty, true);
        expect(sc.steps.length >= 2, true);

        for (final step in sc.steps) {
          expect(step.situationAr.isNotEmpty, true);
          expect(step.options.length >= 2, true);

          final hasSafeChoice = step.options.any((o) => o.isSafe);
          final hasUnsafeChoice = step.options.any((o) => !o.isSafe);
          expect(hasSafeChoice, true, reason: 'Step ${step.id} in ${sc.id} must have at least one safe choice');
          expect(hasUnsafeChoice, true, reason: 'Step ${step.id} in ${sc.id} must have at least one unsafe choice');

          for (final opt in step.options) {
            expect(opt.textAr.isNotEmpty, true);
            expect(opt.explanationAr.isNotEmpty, true);
          }
        }
      }
    });

    test('Official Saudi emergency contacts are present and valid', () {
      final contacts = InitialSeedData.emergencyContacts;
      expect(contacts.length >= 7, true);

      final numbers = contacts.map((c) => c.number).toSet();
      expect(numbers.contains('911'), true);
      expect(numbers.contains('998'), true);
      expect(numbers.contains('997'), true);
      expect(numbers.contains('996'), true);
      expect(numbers.contains('993'), true);
      expect(numbers.contains('933'), true);
    });

    test('Offline knowledge articles contain structured step-by-step guides', () {
      final articles = InitialSeedData.knowledgeArticles;
      expect(articles.length >= 4, true);

      for (final art in articles) {
        expect(art.titleAr.isNotEmpty, true);
        expect(art.summaryAr.isNotEmpty, true);
        expect(art.contentAr.isNotEmpty, true);
        expect(art.stepsAr.isNotEmpty, true);
      }
    });
  });

  group('Localization Tests', () {
    test('AppLocalizations translates Arabic and English correctly', () {
      final arLoc = AppLocalizations(const Locale('ar'));
      expect(arLoc.translate('appName'), 'جاهز للطوارئ');
      expect(arLoc.translate('startSimulation'), 'ابدأ محاكاة');
      expect(arLoc.isArabic, true);

      final enLoc = AppLocalizations(const Locale('en'));
      expect(enLoc.translate('appName'), 'Emergency Ready');
      expect(enLoc.translate('startSimulation'), 'Start Simulation');
      expect(enLoc.isArabic, false);
    });
  });
}
