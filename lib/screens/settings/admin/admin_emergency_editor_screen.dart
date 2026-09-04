import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/emergency_contact.dart';
import '../../../providers/admin_provider.dart';
import '../../../widgets/custom_card.dart';

class AdminEmergencyEditorScreen extends StatefulWidget {
  final EmergencyContact? contactToEdit;

  const AdminEmergencyEditorScreen({super.key, this.contactToEdit});

  @override
  State<AdminEmergencyEditorScreen> createState() => _AdminEmergencyEditorScreenState();
}

class _AdminEmergencyEditorScreenState extends State<AdminEmergencyEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameArController;
  late TextEditingController _nameEnController;
  late TextEditingController _numberController;
  late TextEditingController _descArController;
  late TextEditingController _descEnController;
  late TextEditingController _priorityController;

  @override
  void initState() {
    super.initState();
    final c = widget.contactToEdit;
    _nameArController = TextEditingController(text: c?.nameAr ?? '');
    _nameEnController = TextEditingController(text: c?.nameEn ?? '');
    _numberController = TextEditingController(text: c?.number ?? '');
    _descArController = TextEditingController(text: c?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: c?.descriptionEn ?? '');
    _priorityController = TextEditingController(text: (c?.priority ?? 1).toString());
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _numberController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _priorityController.dispose();
    super.dispose();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final id = widget.contactToEdit?.id ?? 'ec_custom_${DateTime.now().millisecondsSinceEpoch}';
    final priority = int.tryParse(_priorityController.text.trim()) ?? 1;

    final contact = EmergencyContact(
      id: id,
      nameAr: _nameArController.text.trim(),
      nameEn: _nameEnController.text.trim().isNotEmpty ? _nameEnController.text.trim() : _nameArController.text.trim(),
      number: _numberController.text.trim(),
      icon: 'phone',
      descriptionAr: _descArController.text.trim(),
      descriptionEn: _descEnController.text.trim(),
      priority: priority,
      isOfficial: true,
    );

    final admin = Provider.of<AdminProvider>(context, listen: false);
    await admin.saveEmergencyContact(contact);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactToEdit == null ? 'إضافة جهة طوارئ جديدة' : 'تعديل جهة الطوارئ'),
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
                      controller: _nameArController,
                      decoration: const InputDecoration(labelText: 'اسم الجهة الرسمية (بالعربية)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nameEnController,
                      decoration: const InputDecoration(labelText: 'Authority Name (English)'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'رقم الطوارئ المباشر (مثل: 911 أو 998)*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descArController,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'وصف الاختصاص وحالات الاتصال*'),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _priorityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'ترتيب الأولوية في العرض (1 = أعلى أولوية)'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('حفظ جهة الطوارئ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
