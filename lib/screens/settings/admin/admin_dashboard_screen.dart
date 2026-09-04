import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_card.dart';
import '../../../widgets/icon_helper.dart';
import 'admin_scenario_editor_screen.dart';
import 'admin_article_editor_screen.dart';
import 'admin_emergency_editor_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final loc = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('adminMode')),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: AppColors.warningOrange),
            tooltip: 'إعادة ضبط قاعدة البيانات للمصنع',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('إعادة ضبط المصنع؟'),
                  content: const Text('سيتم استعادة جميع السيناريوهات والمقالات والأرقام الافتراضية وإعادة تعيين البيانات.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(loc.translate('cancel'))),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.warningOrange),
                      child: const Text('إعادة تعيين'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await admin.resetDatabase();
              }
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary,
          labelColor: isDark ? AppColors.secondaryLight : AppColors.secondaryDark,
          unselectedLabelColor: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'السيناريوهات', icon: Icon(Icons.play_circle_outline, size: 20)),
            Tab(text: 'مركز المعرفة', icon: Icon(Icons.menu_book, size: 20)),
            Tab(text: 'أرقام الطوارئ', icon: Icon(Icons.phone, size: 20)),
          ],
        ),
      ),
      body: admin.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : TabBarView(
              controller: _tabController,
              children: [
                // 1. Scenarios Tab
                Scaffold(
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminScenarioEditorScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('إضافة سيناريو', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    backgroundColor: AppColors.primary,
                  ),
                  body: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    itemCount: admin.scenarios.length,
                    itemBuilder: (context, index) {
                      final sc = admin.scenarios[index];
                      final catColor = AppColors.getCategoryColor(sc.categoryId);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: catColor.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(IconHelper.getIcon(sc.icon), color: catColor, size: 22),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          sc.titleAr,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w800,
                                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                          ),
                                        ),
                                        Text(
                                          '${sc.steps.length} محطات قرار • ${sc.difficulty}',
                                          style: TextStyle(
                                            fontSize: 11.5,
                                            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.primary),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AdminScenarioEditorScreen(scenarioToEdit: sc),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.emergencyRed),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('حذف السيناريو؟'),
                                          content: Text('هل أنت متأكد من حذف سيناريو "${sc.titleAr}"؟'),
                                          actions: [
                                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(loc.translate('cancel'))),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(ctx, true),
                                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
                                              child: Text(loc.translate('delete')),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await admin.deleteScenario(sc.id);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 2. Knowledge Articles Tab
                Scaffold(
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminArticleEditorScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('إضافة مقال', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    backgroundColor: AppColors.primary,
                  ),
                  body: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    itemCount: admin.articles.length,
                    itemBuilder: (context, index) {
                      final art = admin.articles[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.infoBlue.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.article, color: AppColors.infoBlue, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      art.titleAr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      '${art.stepsAr.length} خطوات • ${art.doListAr.length} إرشادات',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminArticleEditorScreen(articleToEdit: art),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.emergencyRed),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('حذف المقال؟'),
                                      content: Text('هل أنت متأكد من حذف مقال "${art.titleAr}"؟'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(loc.translate('cancel'))),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
                                          child: Text(loc.translate('delete')),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await admin.deleteArticle(art.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 3. Emergency Contacts Tab
                Scaffold(
                  floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminEmergencyEditorScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('إضافة رقم طوارئ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    backgroundColor: AppColors.primary,
                  ),
                  body: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    itemCount: admin.emergencyContacts.length,
                    itemBuilder: (context, index) {
                      final c = admin.emergencyContacts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.emergencyRed.withOpacity(0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.phone_in_talk, color: AppColors.emergencyRed, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c.nameAr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                      ),
                                    ),
                                    Text(
                                      'الرقم: ${c.number} • أولوية: ${c.priority}',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminEmergencyEditorScreen(contactToEdit: c),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.emergencyRed),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('حذف الرقم؟'),
                                      content: Text('هل أنت متأكد من حذف "${c.nameAr}"؟'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(loc.translate('cancel'))),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.emergencyRed),
                                          child: Text(loc.translate('delete')),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await admin.deleteEmergencyContact(c.id);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
