import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/knowledge_article.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_card.dart';

class AdminArticleEditorScreen extends StatefulWidget {
  final KnowledgeArticle? articleToEdit;

  const AdminArticleEditorScreen({super.key, this.articleToEdit});

  @override
  State<AdminArticleEditorScreen> createState() => _AdminArticleEditorScreenState();
}

class _AdminArticleEditorScreenState extends State<AdminArticleEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleArController;
  late TextEditingController _titleEnController;
  late TextEditingController _summaryArController;
  late TextEditingController _contentArController;
  late TextEditingController _stepsController;
  late TextEditingController _dosController;
  late TextEditingController _dontsController;
  String _selectedCategory = 'fire';

  @override
  void initState() {
    super.initState();
    final art = widget.articleToEdit;
    _titleArController = TextEditingController(text: art?.titleAr ?? '');
    _titleEnController = TextEditingController(text: art?.titleEn ?? '');
    _summaryArController = TextEditingController(text: art?.summaryAr ?? '');
    _contentArController = TextEditingController(text: art?.contentAr ?? '');
    _stepsController = TextEditingController(text: art?.stepsAr.join('\n') ?? '');
    _dosController = TextEditingController(text: art?.doListAr.join('\n') ?? '');
    _dontsController = TextEditingController(text: art?.dontListAr.join('\n') ?? '');
    _selectedCategory = art?.categoryId ?? 'fire';
  }

  @override
  void dispose() {
    _titleArController.dispose();
    _titleEnController.dispose();
    _summaryArController.dispose();
    _contentArController.dispose();
    _stepsController.dispose();
    _dosController.dispose();
    _dontsController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.articleToEdit?.id ?? 'art_custom_${DateTime.now().millisecondsSinceEpoch}';
    final steps = _stepsController.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final dos = _dosController.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final donts = _dontsController.text.split('\n').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    final article = KnowledgeArticle(
      id: id,
      categoryId: _selectedCategory,
      titleAr: _titleArController.text.trim(),
      titleEn: _titleEnController.text.trim().isNotEmpty ? _titleEnController.text.trim() : _titleArController.text.trim(),
      summaryAr: _summaryArController.text.trim(),
      summaryEn: _summaryArController.text.trim(),
      contentAr: _contentArController.text.trim(),
      contentEn: _contentArController.text.trim(),
      icon: 'menu_book',
      stepsAr: steps,
      stepsEn: steps,
      doListAr: dos,
      doListEn: dos,
      dontListAr: donts,
      dontListEn: donts,
      readingTimeMinutes: 3,
    );

    final admin = Provider.of<AdminProvider>(context, listen: false);
    await admin.saveArticle(article);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.articleToEdit == null ? 'إضافة مقال تعليمي جديد' : 'تعديل المقال'),
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
              CustomCard(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleArController,
                      decoration: const InputDecoration(labelText: 'عنوان المقال (بالعربية)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleEnController,
                      decoration: const InputDecoration(labelText: 'Article Title (English)'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'مجال المقال (Category)'),
                      items: admin.categories.map((cat) {
                        return DropdownMenuItem(value: cat.id, child: Text(cat.titleAr));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _summaryArController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'الموجز / الخلاصة*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contentArController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'نص المقال والشرح التفصيلي*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('خطوات الاستجابة (سطر لكل خطوة)', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _stepsController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'الخطوة الأولى\nالخطوة الثانية\nالخطوة الثالثة',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('قائمة ما يجب فعله (افعل - سطر لكل بند)', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.safeGreen)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dosController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'إجراء آمن 1\nإجراء آمن 2',
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('قائمة ما يجب تجنبه (لا تفعل - سطر لكل بند)', style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.emergencyRed)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dontsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'خطر يجب تجنبه 1\nخطر يجب تجنبه 2',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('حفظ المقال التعليمي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
