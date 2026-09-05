import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_card.dart';

class CarCheckItem {
  final String id;
  final String titleAr;
  final String subtitleAr;
  final IconData icon;
  bool isChecked;

  CarCheckItem({
    required this.id,
    required this.titleAr,
    required this.subtitleAr,
    required this.icon,
    this.isChecked = false,
  });
}

class HighwayCarChecklistScreen extends StatefulWidget {
  const HighwayCarChecklistScreen({super.key});

  @override
  State<HighwayCarChecklistScreen> createState() => _HighwayCarChecklistScreenState();
}

class _HighwayCarChecklistScreenState extends State<HighwayCarChecklistScreen> {
  final List<CarCheckItem> _carItems = [
    CarCheckItem(
      id: 'c1',
      titleAr: 'الإطار الاحتياطي (السبير) ومفتاح العجلات',
      subtitleAr: 'التأكد من ضغط السبير وعمل العفريتة ومفتاح العجلات',
      icon: Icons.tire_repair,
      isChecked: true,
    ),
    CarCheckItem(
      id: 'c2',
      titleAr: 'طفاية حريق المركبة',
      subtitleAr: 'مثبتة جيدا ومؤشر الضغط باللون الأخضر وتاريخها ساري',
      icon: Icons.fire_extinguisher,
      isChecked: true,
    ),
    CarCheckItem(
      id: 'c3',
      titleAr: 'مثلث السلامة العاكس والسترة',
      subtitleAr: 'وضع المثلث العاكس على بعد 50 متر عند التوقف الاضطراري',
      icon: Icons.warning_amber,
      isChecked: false,
    ),
    CarCheckItem(
      id: 'c4',
      titleAr: 'سائل تبريد الرديتر ومستوى الزيت',
      subtitleAr: 'فحص خزان التبريد قبل التشغيل وعدم فتحه أثناء السخونة',
      icon: Icons.oil_barrel_outlined,
      isChecked: true,
    ),
    CarCheckItem(
      id: 'c5',
      titleAr: 'حقيبة الإسعافات الأولية بالمركبة',
      subtitleAr: 'تأكد من وجود اللواصق والمعقم ومحلول غسيل العين',
      icon: Icons.medical_services_outlined,
      isChecked: false,
    ),
  ];

  int get _checkedCount => _carItems.where((i) => i.isChecked).length;
  bool get _isAllChecked => _checkedCount == _carItems.length;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _checkedCount / _carItems.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('فحص المركبة قبل الخطوط السريعة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Vehicle Status Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isAllChecked
                      ? [const Color(0xFF10B981), const Color(0xFF059669)]
                      : (isDark
                          ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                          : [Colors.white, const Color(0xFFF1F5F9)]),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isAllChecked ? Colors.transparent : AppColors.primary.withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: (_isAllChecked ? AppColors.safeGreen : AppColors.primary).withOpacity(0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isAllChecked ? Colors.white.withOpacity(0.2) : AppColors.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isAllChecked ? Icons.verified_user : Icons.directions_car,
                      color: _isAllChecked ? Colors.white : AppColors.primary,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isAllChecked ? 'المركبة جاهزة للسفر 100%' : 'فحص سلامة السيارة للخطوط',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isAllChecked
                                ? Colors.white
                                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'تم تأكيد $_checkedCount من أصل ${_carItems.length} متطلبات أمان.',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: _isAllChecked
                                ? Colors.white.withOpacity(0.9)
                                : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Progress Line
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _isAllChecked ? AppColors.safeGreen : AppColors.primary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Checklist Items
            ..._carItems.map((item) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  onTap: () {
                    setState(() {
                      item.isChecked = !item.isChecked;
                      if (item.isChecked) {
                        AudioService.instance.playSuccess();
                      } else {
                        AudioService.instance.playClick();
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: item.isChecked,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            item.isChecked = val ?? false;
                            if (item.isChecked) {
                              AudioService.instance.playSuccess();
                            } else {
                              AudioService.instance.playClick();
                            }
                          });
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.isChecked
                              ? AppColors.primary.withOpacity(0.15)
                              : Colors.grey.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.isChecked ? AppColors.primary : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.titleAr,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.subtitleAr,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
