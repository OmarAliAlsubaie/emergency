import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_profile.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/preparedness_provider.dart';
import '../../providers/achievements_provider.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/nano_image_widget.dart';
import '../../core/constants/nano_banana_assets.dart';

class ProfileManagementScreen extends StatelessWidget {
  const ProfileManagementScreen({super.key});

  void _showAddEditProfileDialog(BuildContext context, {UserProfile? profileToEdit}) {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final nameController = TextEditingController(text: profileToEdit?.name ?? '');
    String selectedRole = profileToEdit?.role ?? 'الأب';
    String selectedAvatar = profileToEdit?.avatar ?? NanoBananaAssets.nanoBoy;

    final roles = ['الأب', 'الأم', 'الابن', 'الابنة', 'فرد العائلة'];
    final avatars = [
      NanoBananaAssets.nanoBoy,
      NanoBananaAssets.nanoGirl,
      NanoBananaAssets.nanoResponder,
      NanoBananaAssets.avatarFather,
      NanoBananaAssets.avatarMother,
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              title: Text(
                profileToEdit == null ? loc.translate('addNewProfile') : 'تعديل الملف الشخصي',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: loc.translate('profileName'),
                        hintText: 'مثال: عبدالله أو سارة',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Role Selector
                    Text(
                      loc.translate('profileRole'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: roles.map((role) {
                        final isSelected = selectedRole == role;
                        return ChoiceChip(
                          label: Text(role),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                            fontWeight: FontWeight.w700,
                          ),
                          onSelected: (val) {
                            setDialogState(() => selectedRole = role);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Avatar Selector
                    Text(
                      'أيقونة الحساب',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: avatars.map((av) {
                        final isSelected = selectedAvatar == av;
                        return InkWell(
                          onTap: () {
                            setDialogState(() => selectedAvatar = av);
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : AppColors.primaryContainer,
                              border: Border.all(
                                color: isSelected ? AppColors.secondary : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: NanoImageWidget(
                              imageSource: av,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(loc.translate('cancel')),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    if (profileToEdit == null) {
                      await appState.addProfile(name, selectedRole, selectedAvatar);
                    } else {
                      final updated = profileToEdit.copyWith(
                        name: name,
                        role: selectedRole,
                        avatar: selectedAvatar,
                      );
                      await appState.updateProfile(updated);
                    }

                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: Text(loc.translate('save')),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final prepProvider = Provider.of<PreparednessProvider>(context, listen: false);
    final achProvider = Provider.of<AchievementsProvider>(context, listen: false);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort family members by preparedness score / XP for leaderboard
    final sortedProfiles = List<UserProfile>.from(appState.profiles)
      ..sort((a, b) => b.preparednessScore.compareTo(a.preparednessScore));

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('familyMode')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditProfileDialog(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(
          loc.translate('addNewProfile'),
          style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Family Mode Description
            CustomCard(
              gradient: const LinearGradient(
                colors: [Color(0xFF006C35), Color(0xFF004D25)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.family_restroom, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'لوحة جاهزية الأسرة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'تدريب أفراد الأسرة وقياس درجة جاهزيتهم بشكل منفصل ومحلي بالكامل دون إنترنت.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'أفراد الأسرة والترتيب التنافسي',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),

            const SizedBox(height: 12),

            // Family Members Leaderboard List
            ...List.generate(sortedProfiles.length, (index) {
              final member = sortedProfiles[index];
              final isActive = member.id == appState.activeProfile?.id;
              final rankBadge = index == 0
                  ? '🥇 الأول'
                  : (index == 1 ? '🥈 الثاني' : (index == 2 ? '🥉 الثالث' : '#${index + 1}'));

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  border: Border.all(
                    color: isActive ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
                    width: isActive ? 2 : 1,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? AppColors.primary : AppColors.primaryContainer,
                              border: Border.all(
                                color: isActive ? AppColors.secondary : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: NanoImageWidget(
                              imageSource: member.avatar,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(26),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      member.name,
                                      style: TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        rankBadge,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.secondaryDark,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${member.role} • ${member.xp} XP • المستوى ${member.level}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${member.preparednessScore}%',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Text(
                                'جاهزية',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textTertiaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!isActive)
                            OutlinedButton.icon(
                              onPressed: () async {
                                await appState.switchProfile(member.id);
                                await prepProvider.loadPreparednessData(member.id);
                                await achProvider.loadAchievements(member.id);
                              },
                              icon: const Icon(Icons.swap_horiz, size: 16),
                              label: const Text('التبديل إليه'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check_circle, color: AppColors.primary, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'الملف النشط حالياً',
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 18),
                                onPressed: () => _showAddEditProfileDialog(context, profileToEdit: member),
                              ),
                              if (appState.profiles.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.emergencyRed, size: 18),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('حذف الملف الشخصي؟'),
                                        content: Text('هل أنت متأكد من حذف ${member.name}؟ ستفقد جميع نقاطه وسجلاته.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, false),
                                            child: Text(loc.translate('cancel')),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(ctx, true),
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
                                            child: Text(loc.translate('delete')),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await appState.deleteProfile(member.id);
                                    }
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
