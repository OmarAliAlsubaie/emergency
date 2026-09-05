import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../achievements/profile_management_screen.dart';
import '../emergency/emergency_info_screen.dart';
import 'admin/admin_login_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // General Preferences
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('التفضيلات العامة', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),

                  // Language Switcher
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.language, color: AppColors.primary),
                    title: Text(loc.translate('language'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(langProvider.isArabic ? 'العربية (RTL)' : 'English (LTR)'),
                    trailing: Switch(
                      value: !langProvider.isArabic,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        langProvider.toggleLocale();
                      },
                    ),
                  ),

                  const Divider(),

                  // Dark Mode
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                    title: Text(loc.translate('darkMode'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(langProvider.isDarkMode ? 'مفعل' : 'معطل'),
                    trailing: Switch(
                      value: langProvider.isDarkMode,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        langProvider.toggleDarkMode();
                      },
                    ),
                  ),

                  const Divider(),

                  // Sound & Haptics
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.volume_up_outlined, color: AppColors.primary),
                    title: Text(loc.translate('soundEffects'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    trailing: Switch(
                      value: langProvider.soundEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        langProvider.toggleSound();
                      },
                    ),
                  ),

                  const Divider(),

                  // Timer during simulation
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.timer_outlined, color: AppColors.primary),
                    title: Text(loc.translate('timerEnabled'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    trailing: Switch(
                      value: langProvider.timerEnabled,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        langProvider.toggleTimer();
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Modules & Navigation Shortcuts
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('إدارة الملفات والطوارئ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),

                  // Family Mode
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.family_restroom, color: AppColors.primary),
                    title: Text(loc.translate('familyMode'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('إدارة أفراد العائلة وسجل كل فرد'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileManagementScreen(),
                        ),
                      );
                    },
                  ),

                  const Divider(),

                  // Emergency Info
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.phone_in_talk, color: AppColors.emergencyRed),
                    title: Text(loc.translate('emergencyNumbers'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('أرقام وإرشادات الطوارئ الرسمية 911 / 998'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmergencyInfoScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Administration Card
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('لوحة التحكم والإشراف', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.admin_panel_settings, color: AppColors.secondaryDark),
                    title: Text(loc.translate('adminMode'), style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('تعديل وإضافة سيناريوهات ومقالات محلياً'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => const AdminLoginDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // About Saudi Ready App
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF006C35), Color(0xFF004D25)],
              ),
              child: Column(
                children: [
                  const Text(
                    AppConstants.appNameAr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    AppConstants.appSubtitleAr,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppConstants.appSloganAr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      AppConstants.appVersion,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
