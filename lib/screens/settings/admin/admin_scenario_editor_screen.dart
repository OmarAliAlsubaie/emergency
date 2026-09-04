import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/scenario.dart';
import '../../../models/scenario_step.dart';
import '../../../models/scenario_option.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_card.dart';

class AdminScenarioEditorScreen extends StatefulWidget {
  final Scenario? scenarioToEdit;

  const AdminScenarioEditorScreen({super.key, this.scenarioToEdit});

  @override
  State<AdminScenarioEditorScreen> createState() => _AdminScenarioEditorScreenState();
}

class _AdminScenarioEditorScreenState extends State<AdminScenarioEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleArController;
  late TextEditingController _titleEnController;
  late TextEditingController _descArController;
  late TextEditingController _descEnController;
  late TextEditingController _timeLimitController;

  String _selectedCategory = 'fire';
  String _selectedDifficulty = 'متوسط';
  List<ScenarioStep> _steps = [];

  @override
  void initState() {
    super.initState();
    final sc = widget.scenarioToEdit;
    _titleArController = TextEditingController(text: sc?.titleAr ?? '');
    _titleEnController = TextEditingController(text: sc?.titleEn ?? '');
    _descArController = TextEditingController(text: sc?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: sc?.descriptionEn ?? '');
    _timeLimitController = TextEditingController(text: (sc?.timeLimitSeconds ?? 15).toString());
    _selectedCategory = sc?.categoryId ?? 'fire';
    _selectedDifficulty = sc?.difficulty ?? 'متوسط';
    _steps = sc != null ? List.from(sc.steps) : [];

    if (_steps.isEmpty) {
      // Add default step 1
      _steps.add(
        ScenarioStep(
          id: 'step_${DateTime.now().millisecondsSinceEpoch}',
          scenarioId: sc?.id ?? '',
          stepOrder: 1,
          situationAr: 'أنت في الموقف الطارئ الأول...',
          situationEn: 'You are in emergency situation 1...',
          options: [
            ScenarioOption(
              id: 'opt_1_${DateTime.now().millisecondsSinceEpoch}',
              stepId: '',
              textAr: 'الخيار الصحيح والآمن',
              textEn: 'Safe and correct option',
              isSafe: true,
              safetyScore: 100,
              speedScore: 25,
              explanationAr: 'تفسير لماذا هذا الخيار آمن وسليم.',
              explanationEn: 'Explanation why safe.',
              outcomeSummaryAr: 'نجوت بأمان.',
              outcomeSummaryEn: 'Survived safely.',
              xpReward: 30,
            ),
            ScenarioOption(
              id: 'opt_2_${DateTime.now().millisecondsSinceEpoch}',
              stepId: '',
              textAr: 'خيار خاطئ ومحفوف بالمخاطر',
              textEn: 'Unsafe option',
              isSafe: false,
              safetyScore: 10,
              speedScore: 0,
              explanationAr: 'تفسير خطورة هذا التصرف.',
              explanationEn: 'Explanation of hazard.',
              outcomeSummaryAr: 'حدث خطر إضافي.',
              outcomeSummaryEn: 'Hazard occurred.',
              xpReward: 0,
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final scId = widget.scenarioToEdit?.id ?? 'sc_custom_${DateTime.now().millisecondsSinceEpoch}';
    final timeLimit = int.tryParse(_timeLimitController.text.trim()) ?? 15;

    // Attach scenarioId to steps
    final updatedSteps = _steps.asMap().entries.map((entry) {
      final idx = entry.key;
      final st = entry.value;
      final stId = st.id.isNotEmpty ? st.id : 'step_${scId}_$idx';
      final updatedOpts = st.options.map((opt) {
        return ScenarioOption(
          id: opt.id.isNotEmpty ? opt.id : 'opt_${DateTime.now().millisecondsSinceEpoch}_${opt.textAr.hashCode}',
          stepId: stId,
          textAr: opt.textAr,
          textEn: opt.textEn,
          isSafe: opt.isSafe,
          safetyScore: opt.safetyScore,
          speedScore: opt.speedScore,
          explanationAr: opt.explanationAr,
          explanationEn: opt.explanationEn,
          outcomeSummaryAr: opt.outcomeSummaryAr,
          outcomeSummaryEn: opt.outcomeSummaryEn,
          xpReward: opt.xpReward,
        );
      }).toList();

      return st.copyWith(
        id: stId,
        scenarioId: scId,
        stepOrder: idx + 1,
        options: updatedOpts,
      );
    }).toList();

    final scenario = Scenario(
      id: scId,
      categoryId: _selectedCategory,
      titleAr: _titleArController.text.trim(),
      titleEn: _titleEnController.text.trim().isNotEmpty ? _titleEnController.text.trim() : _titleArController.text.trim(),
      descriptionAr: _descArController.text.trim(),
      descriptionEn: _descEnController.text.trim().isNotEmpty ? _descEnController.text.trim() : _descArController.text.trim(),
      difficulty: _selectedDifficulty,
      timeLimitSeconds: timeLimit,
      icon: 'local_fire_department',
      colorHex: AppColors.getCategoryColor(_selectedCategory).value,
      steps: updatedSteps,
    );

    final admin = Provider.of<AdminProvider>(context, listen: false);
    await admin.saveScenario(scenario);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scenarioToEdit == null ? 'إضافة سيناريو محاكاة جديد' : 'تعديل السيناريو'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primary),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Information Card
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('بيانات السيناريو الأساسية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _titleArController,
                      decoration: const InputDecoration(labelText: 'عنوان السيناريو (بالعربية)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleEnController,
                      decoration: const InputDecoration(labelText: 'Scenario Title (English)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descArController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'وصف وسياق السيناريو (بالعربية)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'مجال الطوارئ (Category)'),
                      items: admin.categories.map((cat) {
                        return DropdownMenuItem(value: cat.id, child: Text(cat.titleAr));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedDifficulty,
                            decoration: const InputDecoration(labelText: 'الصعوبة'),
                            items: const [
                              DropdownMenuItem(value: 'مبتدئ', child: Text('مبتدئ')),
                              DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                              DropdownMenuItem(value: 'متقدم', child: Text('متقدم')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedDifficulty = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _timeLimitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'المؤقت (بالثواني)'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Steps & Choices Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'محطات القرار التفاعلية (${_steps.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _steps.add(
                          ScenarioStep(
                            id: 'step_${DateTime.now().millisecondsSinceEpoch}',
                            scenarioId: '',
                            stepOrder: _steps.length + 1,
                            situationAr: 'موقف طارئ جديد...',
                            situationEn: 'New situation...',
                            options: [
                              ScenarioOption(
                                id: 'opt_${DateTime.now().millisecondsSinceEpoch}',
                                stepId: '',
                                textAr: 'خيار آمن',
                                textEn: 'Safe choice',
                                isSafe: true,
                                safetyScore: 100,
                                speedScore: 25,
                                explanationAr: 'تفسير القرار.',
                                explanationEn: 'Explanation.',
                                outcomeSummaryAr: 'نجاح.',
                                outcomeSummaryEn: 'Success.',
                                xpReward: 30,
                              ),
                            ],
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة محطة'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              ...List.generate(_steps.length, (stIndex) {
                final step = _steps[stIndex];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'المحطة #${stIndex + 1}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary),
                            ),
                            if (_steps.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.emergencyRed, size: 18),
                                onPressed: () {
                                  setState(() => _steps.removeAt(stIndex));
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: step.situationAr,
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: 'وصف الموقف الطارئ*'),
                          onChanged: (val) {
                            _steps[stIndex] = step.copyWith(situationAr: val);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'خيارات القرار (${step.options.length}):',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ...List.generate(step.options.length, (optIndex) {
                          final opt = step.options[optIndex];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: opt.isSafe ? AppColors.safeGreenLight : AppColors.emergencyRedLight,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: opt.isSafe ? AppColors.safeGreen : AppColors.emergencyRed),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      opt.isSafe ? Icons.check_circle : Icons.cancel,
                                      color: opt.isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        opt.textAr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: opt.isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      opt.isSafe ? 'آمن (+${opt.xpReward} XP)' : 'غير آمن (0 XP)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: opt.isSafe ? AppColors.safeGreen : AppColors.emergencyRed,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'التفسير: ${opt.explanationAr}',
                                  style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('حفظ ونشر السيناريو محلياً', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
