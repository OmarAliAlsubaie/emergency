import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/app_state_provider.dart';
import '../../../providers/preparedness_provider.dart';
import '../../../providers/achievements_provider.dart';
import '../../../widgets/nano_image_widget.dart';
import '../../achievements/profile_management_screen.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  void _showProfileSwitchSheet(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final prepProvider = Provider.of<PreparednessProvider>(context, listen: false);
    final achProvider = Provider.of<AchievementsProvider>(context, listen: false);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.translate('switchProfile'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileManagementScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.group_add, size: 18),
                      label: Text(loc.translate('familyMode')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...appState.profiles.map((profile) {
                  final isSelected = profile.id == appState.activeProfile?.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.12)
                          : (isDark ? AppColors.surfaceElevatedDark : const Color(0xFFF7F9F8)),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      leading: NanoImageWidget(
                        imageSource: profile.avatar,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      title: Text(
                        profile.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      subtitle: Text(
                        'جاهزية ${profile.preparednessScore}% • ${loc.isArabic ? profile.levelTitleAr : profile.levelTitleEn} • ${profile.xp} XP',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                      onTap: () async {
                        await appState.switchProfile(profile.id);
                        if (context.mounted) {
                          await prepProvider.loadPreparednessData(profile.id);
                          await achProvider.loadAchievements(profile.id);
                        }
                        if (ctx.mounted) {
                          Navigator.pop(ctx);
                        }
                      },
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profile = appState.activeProfile;

    if (profile == null) return const SizedBox.shrink();

    final levelProgress = AppConstants.calculateLevelProgress(profile.xp);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Avatar with mint green background
          InkWell(
            onTap: () => _showProfileSwitchSheet(context),
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFA2E8DD),
                  ),
                  child: NanoImageWidget(
                    imageSource: profile.avatar,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(36),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF4DB6AC),
                    ),
                    child: const Icon(
                      Icons.swap_horiz,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // User Level, XP Badge, and Smooth Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          loc.isArabic ? 'مرحباً ${profile.name}' : 'Welcome ${profile.name}',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : const Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.waving_hand_rounded,
                          color: Color(0xFFFFB300),
                          size: 20,
                        ),
                      ],
                    ),
                    // XP Badge & Level Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD54F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.hexagon_rounded,
                                size: 12,
                                color: Color(0xFF5D4037),
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'XP ${profile.xp}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF3E2723),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Smooth mint progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: levelProgress.clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: const Color(0xFFE0F2F1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4DB6AC)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
