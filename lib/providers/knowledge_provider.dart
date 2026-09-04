import 'package:flutter/material.dart';
import '../core/database/database_helper.dart';
import '../models/knowledge_article.dart';
import '../models/category.dart';

class KnowledgeProvider extends ChangeNotifier {
  List<KnowledgeArticle> _articles = [];
  List<SimulationCategory> _categories = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _onlyBookmarks = false;
  bool _isLoading = true;

  List<KnowledgeArticle> get articles => _filteredArticles();
  List<SimulationCategory> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  bool get onlyBookmarks => _onlyBookmarks;
  bool get isLoading => _isLoading;

  Future<void> loadKnowledge(String profileId) async {
    _isLoading = true;

    try {
      _categories = await DatabaseHelper.instance.getAllCategories();
      _articles = await DatabaseHelper.instance.getArticles(profileId: profileId);
    } catch (e) {
      debugPrint('Error loading knowledge: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String catId) {
    _selectedCategoryId = catId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleOnlyBookmarks() {
    _onlyBookmarks = !_onlyBookmarks;
    notifyListeners();
  }

  Future<void> toggleBookmark(String profileId, String articleId, bool currentBookmark) async {
    final newStatus = !currentBookmark;
    await DatabaseHelper.instance.toggleArticleBookmark(profileId, articleId, newStatus);

    _articles = _articles.map((art) {
      if (art.id == articleId) {
        return art.copyWith(isBookmarked: newStatus);
      }
      return art;
    }).toList();

    notifyListeners();
  }

  List<KnowledgeArticle> _filteredArticles() {
    return _articles.where((art) {
      // Category filter
      if (_selectedCategoryId != 'all' && art.categoryId != _selectedCategoryId) {
        return false;
      }
      // Bookmarks filter
      if (_onlyBookmarks && !art.isBookmarked) {
        return false;
      }
      // Search filter
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchTitle = art.titleAr.toLowerCase().contains(query) || art.titleEn.toLowerCase().contains(query);
        final matchSummary = art.summaryAr.toLowerCase().contains(query) || art.summaryEn.toLowerCase().contains(query);
        final matchContent = art.contentAr.toLowerCase().contains(query) || art.contentEn.toLowerCase().contains(query);
        return matchTitle || matchSummary || matchContent;
      }
      return true;
    }).toList();
  }
}
