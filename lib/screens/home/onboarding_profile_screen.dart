import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/nano_banana_assets.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/preparedness_provider.dart';
import '../../widgets/nano_image_widget.dart';
import '../main_navigation_screen.dart';

class OnboardingProfileScreen extends StatefulWidget {
  const OnboardingProfileScreen({super.key});

  @override
  State<OnboardingProfileScreen> createState() => _OnboardingProfileScreenState();
}

class _OnboardingProfileScreenState extends State<OnboardingProfileScreen> {
  final List<Map<String, String>> _cartoonAvatars = [
    {'id': 'nano_boy', 'asset': NanoBananaAssets.nanoBoy, 'name': 'البطل بطلنا'},
    {'id': 'nano_girl', 'asset': NanoBananaAssets.nanoGirl, 'name': 'البطلة'},
    {'id': 'nano_responder', 'asset': NanoBananaAssets.nanoResponder, 'name': 'رجال الطوارئ'},
    {'id': 'avatar_father', 'asset': NanoBananaAssets.avatarFather, 'name': 'الأب'},
    {'id': 'avatar_mother', 'asset': NanoBananaAssets.avatarMother, 'name': 'الأم'},
  ];

  void _showAddProfileModal(BuildContext context) {
    final nameCtrl = TextEditingController();
    String selectedRole = 'الأبن';
    String selectedAvatarAsset = NanoBananaAssets.nanoBoy;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalCtx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 20,
                bottom: MediaQuery.of(modalCtx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'إضافة مستخدم جديد',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 1. Avatar Selection Section (PLACED FIRST AT THE TOP with 3X Giant Avatars)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'اختر الشخصية',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF006C35),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.palette_rounded,
                        color: Color(0xFFFFB300),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // 3X Larger Horizontal Scrollable Character List (135x135 avatars)
                  SizedBox(
                    height: 155,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: _cartoonAvatars.length,
                      itemBuilder: (context, index) {
                        final av = _cartoonAvatars[index];
                        final isSelected = selectedAvatarAsset == av['asset'];

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              selectedAvatarAsset = av['asset']!;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [Color(0xFF00FF7F), AppColors.primary],
                                          )
                                        : null,
                                    border: Border.all(
                                      color: isSelected ? AppColors.primary : Colors.transparent,
                                      width: isSelected ? 4 : 0,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.4),
                                              blurRadius: 14,
                                              offset: const Offset(0, 5),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: NanoImageWidget(
                                    imageSource: av['asset']!,
                                    width: 115,
                                    height: 115,
                                    fit: BoxFit.cover,
                                    borderRadius: BorderRadius.circular(57.5),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  av['name']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                    color: isSelected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Name Field (BELOW CHARACTER SELECTION)
                  Text(
                    'اسم المستخدم',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      hintText: 'أدخل الاسم (مثال: عبدالله)...',
                      filled: true,
                      fillColor: isDark ? AppColors.surfaceElevatedDark : const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) return;

                      final appState = Provider.of<AppStateProvider>(context, listen: false);
                      await appState.addProfile(name, selectedRole, selectedAvatarAsset);

                      if (context.mounted && appState.activeProfile != null) {
                        final prep = Provider.of<PreparednessProvider>(context, listen: false);
                        await prep.loadPreparednessData(appState.activeProfile!.id);

                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'حفظ وابدأ التدريب',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.rocket_launch_rounded,
                          color: Color(0xFFFFD54F),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profiles = appState.profiles;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header (Netflix Style Profile Selection)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'من يتدرب الآن؟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF006C35),
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'اختر حسابك للبدء بالمحاكاة وتخصيص الجاهزية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 36),

              // Netflix Style Users Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: profiles.length + 1, // +1 for '+' add box
                  itemBuilder: (context, index) {
                    // Last Box: '+' Add User Box
                    if (index == profiles.length) {
                      return GestureDetector(
                        onTap: () => _showAddProfileModal(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  size: 58,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'إضافة جديد',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Existing Profile Box
                    final profile = profiles[index];
                    final avatarPath = profile.avatar;

                    return GestureDetector(
                      onTap: () async {
                        await appState.switchProfile(profile.id);
                        if (context.mounted) {
                          final prep = Provider.of<PreparednessProvider>(context, listen: false);
                          await prep.loadPreparednessData(profile.id);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00FF7F), AppColors.primary],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.35),
                                    blurRadius: 14,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: NanoImageWidget(
                                imageSource: avatarPath,
                                width: 165,
                                height: 165,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(82.5),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              profile.name,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'المستوى ${profile.level} • جاهزية ${profile.preparednessScore}%',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Brand Note
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shield_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'جاهز للطوارئ 911 • منصة الجاهزية التفاعلية',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
