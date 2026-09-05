import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/custom_card.dart';

class RoomInspectionItem {
  final String id;
  final String titleAr;
  final String subtitleAr;
  final IconData icon;
  final bool isCritical;
  bool isChecked;

  RoomInspectionItem({
    required this.id,
    required this.titleAr,
    required this.subtitleAr,
    required this.icon,
    this.isCritical = false,
    this.isChecked = false,
  });
}

class HomeSafetyInspectorScreen extends StatefulWidget {
  const HomeSafetyInspectorScreen({super.key});

  @override
  State<HomeSafetyInspectorScreen> createState() => _HomeSafetyInspectorScreenState();
}

class _HomeSafetyInspectorScreenState extends State<HomeSafetyInspectorScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<String, List<RoomInspectionItem>> _roomData = {
    'kitchen': [
      RoomInspectionItem(
        id: 'k1',
        titleAr: 'طفاية الحريق قابلة للاستخدام',
        subtitleAr: 'مؤشر الضغط في المنطقة الخضراء ولم تتجاوز تاريخ الصلاحية',
        icon: Icons.fire_extinguisher,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'k2',
        titleAr: 'بطانية الحريق متوفرة بقرب المطبخ',
        subtitleAr: 'موضوعة في مكان ظاهر وسهل الوصول بعيداً عن الموقد المباشر',
        icon: Icons.shield_outlined,
        isCritical: true,
        isChecked: false,
      ),
      RoomInspectionItem(
        id: 'k3',
        titleAr: 'سلامة صمام وخرطوم الغاز',
        subtitleAr: 'عدم وجود تسريب أو تشققات وتوفير كاشف غاز مغناطيسي',
        icon: Icons.propane_tank_outlined,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'k4',
        titleAr: 'تنظيف شفاط الدهون بالفرن',
        subtitleAr: 'إزالة تراكم الزيوت والدهون لتجنب الاشتعال المفاجئ',
        icon: Icons.cleaning_services_outlined,
        isChecked: false,
      ),
    ],
    'living': [
      RoomInspectionItem(
        id: 'l1',
        titleAr: 'اختبار كاشف الدخان',
        subtitleAr: 'فحص الصوت والبطارية والتأكد من تثبيته بالسقف',
        icon: Icons.sensors,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'l2',
        titleAr: 'خلو الممرات ومسارات الإخلاء',
        subtitleAr: 'عدم وجود عوائق أو أثاث يحجب الأبواب والمخارج',
        icon: Icons.meeting_room,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'l3',
        titleAr: 'عدم التحميل الزائد على المشتركات',
        subtitleAr: 'عدم توصيل أجهزة عالية الاستهلاك بمقابس مشتركة ضعيفة',
        icon: Icons.power_outlined,
        isCritical: true,
        isChecked: false,
      ),
      RoomInspectionItem(
        id: 'l4',
        titleAr: 'حقيبة الإسعافات الأولية جاهزة',
        subtitleAr: 'مكتملة الأربطة وشاش المعقم مع التأكد من تاريخ الأدوية',
        icon: Icons.medical_services_outlined,
        isChecked: true,
      ),
    ],
    'garage': [
      RoomInspectionItem(
        id: 'g1',
        titleAr: 'لوحة التوزيع والتواطع الكهربائية',
        subtitleAr: 'سهولة الوصول للوحة دون وجود عوائق وسلامة القواطع الحساسة',
        icon: Icons.electric_bolt,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'g2',
        titleAr: 'تخزين المواد الكيميائية والدهانات',
        subtitleAr: 'حفظها في خزانة محكمة مغلقة بعيداً عن مصادر الحرارة والشرر',
        icon: Icons.science_outlined,
        isChecked: false,
      ),
      RoomInspectionItem(
        id: 'g3',
        titleAr: 'إضاءة طوارئ تلقائية',
        subtitleAr: 'وجود كشافات طوارئ تعمل مباشرة عند انقطاع التيار',
        icon: Icons.lightbulb_outlined,
        isChecked: true,
      ),
    ],
    'roof': [
      RoomInspectionItem(
        id: 'r1',
        titleAr: 'تنظيف مصارف مياه الأمطار بالسطح',
        subtitleAr: 'التأكد من عدم انسداد المزاريب بالأتربة قبل موسم الأمطار',
        icon: Icons.water_drop_outlined,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'r2',
        titleAr: 'إغلاق غطاء خزان المياه بالكامل',
        subtitleAr: 'التأكد من إحكام إغلاق الخزان العلوي لحماية الأطفال والماء',
        icon: Icons.water_damage_outlined,
        isCritical: true,
        isChecked: true,
      ),
      RoomInspectionItem(
        id: 'r3',
        titleAr: 'تثبيت الأطباق والألواح الشمسية',
        subtitleAr: 'مراجعة تثبيت الأجسام المعرضة للرياح القوية',
        icon: Icons.domain_verification,
        isChecked: false,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _totalItems {
    int count = 0;
    _roomData.forEach((_, items) => count += items.length);
    return count;
  }

  int get _checkedItems {
    int count = 0;
    _roomData.forEach((_, items) {
      count += items.where((i) => i.isChecked).length;
    });
    return count;
  }

  double get _safetyPercentage {
    if (_totalItems == 0) return 0;
    return (_checkedItems / _totalItems) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percentage = _safetyPercentage.round();

    Color scoreColor;
    if (percentage >= 80) {
      scoreColor = AppColors.safeGreen;
    } else if (percentage >= 50) {
      scoreColor = AppColors.warningOrange;
    } else {
      scoreColor = AppColors.emergencyRed;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('مفتش السلامة المنزلية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'إعادة ضبط التقييم',
            onPressed: () {
              setState(() {
                _roomData.forEach((_, items) {
                  for (var item in items) {
                    item.isChecked = false;
                  }
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dynamic Safety Gauge Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [Colors.white, const Color(0xFFF8FAFC)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: scoreColor.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: scoreColor.withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              children: [
                // Animated Progress Ring
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _safetyPercentage / 100,
                        strokeWidth: 8,
                        backgroundColor: scoreColor.withOpacity(0.15),
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home_work_outlined, color: scoreColor, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'مؤشر جاهزية المنزل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'تم فحص $_checkedItems من أصل $_totalItems عنصر سلامة منزلية.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Room Tabs Bar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: const [
              Tab(icon: Icon(Icons.kitchen), text: 'المطبخ'),
              Tab(icon: Icon(Icons.weekend), text: 'الصالة الغرف'),
              Tab(icon: Icon(Icons.garage), text: 'الكراج الكهرباء'),
              Tab(icon: Icon(Icons.roofing), text: 'السطح والخارج'),
            ],
          ),

          const SizedBox(height: 8),

          // Tab View Items
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInspectionList(_roomData['kitchen']!, isDark),
                _buildInspectionList(_roomData['living']!, isDark),
                _buildInspectionList(_roomData['garage']!, isDark),
                _buildInspectionList(_roomData['roof']!, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionList(List<RoomInspectionItem> items, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
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
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: item.isChecked
                        ? AppColors.primary.withOpacity(0.15)
                        : (item.isCritical ? AppColors.emergencyRed.withOpacity(0.12) : Colors.grey.withOpacity(0.12)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.isChecked
                        ? AppColors.primary
                        : (item.isCritical ? AppColors.emergencyRed : Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.titleAr,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ),
                          if (item.isCritical)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.emergencyRed.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'أساسي',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.emergencyRed,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
      },
    );
  }
}
