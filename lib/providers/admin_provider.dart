import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/scenario.dart';
import '../models/knowledge_article.dart';
import '../models/emergency_contact.dart';
import '../models/category.dart';

class AdminProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  List<Scenario> _scenarios = [];
  List<KnowledgeArticle> _articles = [];
  List<EmergencyContact> _emergencyContacts = [];
  List<SimulationCategory> _categories = [];
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  List<Scenario> get scenarios => _scenarios;
  List<KnowledgeArticle> get articles => _articles;
  List<EmergencyContact> get emergencyContacts => _emergencyContacts;
  List<SimulationCategory> get categories => _categories;
  bool get isLoading => _isLoading;

  bool authenticate(String pin) {
    if (pin == '1234' || pin == '911') {
      _isAuthenticated = true;
      loadAllAdminData();
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> loadAllAdminData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await DatabaseHelper.instance.getAllCategories();
      _scenarios = await DatabaseHelper.instance.getAllScenarios();
      _articles = await DatabaseHelper.instance.getArticles();
      _emergencyContacts = await DatabaseHelper.instance.getAllEmergencyContacts();
    } catch (e) {
      debugPrint('Admin load error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- Scenario Management ---
  Future<void> saveScenario(Scenario scenario) async {
    await DatabaseHelper.instance.saveScenario(scenario);
    await loadAllAdminData();
  }

  Future<void> deleteScenario(String scenarioId) async {
    await DatabaseHelper.instance.deleteScenario(scenarioId);
    await loadAllAdminData();
  }

  // --- Article Management ---
  Future<void> saveArticle(KnowledgeArticle article) async {
    await DatabaseHelper.instance.saveKnowledgeArticle(article);
    await loadAllAdminData();
  }

  Future<void> deleteArticle(String articleId) async {
    await DatabaseHelper.instance.deleteKnowledgeArticle(articleId);
    await loadAllAdminData();
  }

  // --- Emergency Contacts Management ---
  Future<void> saveEmergencyContact(EmergencyContact contact) async {
    await DatabaseHelper.instance.saveEmergencyContact(contact);
    await loadAllAdminData();
  }

  Future<void> deleteEmergencyContact(String contactId) async {
    await DatabaseHelper.instance.deleteEmergencyContact(contactId);
    await loadAllAdminData();
  }

  // --- Reset Database ---
  Future<void> resetDatabase() async {
    _isLoading = true;
    notifyListeners();

    await DatabaseHelper.instance.resetToFactoryDefaults();
    await loadAllAdminData();

    _isLoading = false;
    notifyListeners();
  }
}
