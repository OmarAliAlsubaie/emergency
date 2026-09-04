import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/database/database_helper.dart';
import '../models/user_profile.dart';

class AppStateProvider extends ChangeNotifier {
  UserProfile? _activeProfile;
  List<UserProfile> _profiles = [];
  bool _isLoading = true;

  UserProfile? get activeProfile => _activeProfile;
  List<UserProfile> get profiles => _profiles;
  bool get isLoading => _isLoading;

  AppStateProvider() {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    _isLoading = true;

    try {
      _profiles = await DatabaseHelper.instance.getAllProfiles();
      if (_profiles.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        final savedId = prefs.getString('active_profile_id');
        if (savedId != null) {
          _activeProfile = _profiles.firstWhere(
            (p) => p.id == savedId,
            orElse: () => _profiles.first,
          );
        } else {
          _activeProfile = _profiles.first;
        }
      }
    } catch (e) {
      debugPrint('Error loading profiles: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshActiveProfile() async {
    if (_activeProfile != null) {
      final updated = await DatabaseHelper.instance.getProfileById(_activeProfile!.id);
      if (updated != null) {
        _activeProfile = updated;
        _profiles = await DatabaseHelper.instance.getAllProfiles();
        notifyListeners();
      }
    }
  }

  Future<void> switchProfile(String profileId) async {
    final found = _profiles.where((p) => p.id == profileId).toList();
    if (found.isNotEmpty) {
      _activeProfile = found.first;
      notifyListeners();

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('active_profile_id', profileId);

        // Update lastActiveAt in SQLite
        final updated = _activeProfile!.copyWith(lastActiveAt: DateTime.now());
        await DatabaseHelper.instance.saveProfile(updated);
      } catch (_) {}
    }
  }

  Future<void> addProfile(String name, String role, String avatar) async {
    final newProfile = UserProfile(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      role: role,
      avatar: avatar,
      xp: 0,
      level: 1,
      preparednessScore: 50,
      createdAt: DateTime.now(),
      lastActiveAt: DateTime.now(),
    );

    await DatabaseHelper.instance.saveProfile(newProfile);
    await loadProfiles();
    await switchProfile(newProfile.id);
  }

  Future<void> updateProfile(UserProfile updated) async {
    await DatabaseHelper.instance.saveProfile(updated);
    if (_activeProfile?.id == updated.id) {
      _activeProfile = updated;
    }
    await loadProfiles();
  }

  Future<void> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) return; // Keep at least one profile
    await DatabaseHelper.instance.deleteProfile(profileId);
    if (_activeProfile?.id == profileId) {
      final remaining = _profiles.where((p) => p.id != profileId).toList();
      if (remaining.isNotEmpty) {
        await switchProfile(remaining.first.id);
      }
    }
    await loadProfiles();
  }

  Future<void> updateActiveProfileStats({required int addedXp, required int newPreparednessScore}) async {
    if (_activeProfile == null) return;
    final currentXp = _activeProfile!.xp + addedXp;
    final currentLevel = (currentXp ~/ 100) + 1;

    final updated = _activeProfile!.copyWith(
      xp: currentXp,
      level: currentLevel,
      preparednessScore: newPreparednessScore,
      lastActiveAt: DateTime.now(),
    );

    _activeProfile = updated;
    await DatabaseHelper.instance.saveProfile(updated);
    await loadProfiles();
  }
}
