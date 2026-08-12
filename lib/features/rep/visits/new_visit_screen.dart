import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/models/visit_model.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import 'providers/rep_visits_provider.dart';

class NewVisitScreen extends ConsumerStatefulWidget {
  final String? clientId;
  final String? clientName;

  const NewVisitScreen({Key? key, this.clientId, this.clientName}) : super(key: key);

  @override
  ConsumerState<NewVisitScreen> createState() => _NewVisitScreenState();
}

class _NewVisitScreenState extends ConsumerState<NewVisitScreen> {
  final _notesController = TextEditingController();
  bool _isCheckedIn = false;
  List<String> _photos = []; // Mock photos

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _checkIn() {
    // In real app: Geolocation check
    setState(() {
      _isCheckedIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تسجيل الموقع بنجاح'), backgroundColor: AppColors.success));
  }

  void _takePhoto() {
    setState(() {
      _photos.add('mock_photo_url_\${_photos.length}');
    });
  }

  Future<void> _finishVisit() async {
    final authState = ref.read(authControllerProvider);
    if (authState is! AuthAuthenticated) return;

    final visit = VisitModel(
      id: const Uuid().v4(),
      repId: authState.user.id,
      clientId: widget.clientId ?? 'c_unknown',
      clientName: widget.clientName ?? 'عميل غير محدد',
      clientAddress: 'عنوان وهمي',
      status: VisitStatus.completed,
      scheduledAt: DateTime.now(),
      completedAt: DateTime.now(),
      photoUrls: _photos,
      notes: _notesController.text,
      latitude: 24.0, // Mock
      longitude: 46.0, // Mock
    );

    final success = await ref.read(visitControllerProvider.notifier).createVisit(visit);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ الزيارة بنجاح'), backgroundColor: AppColors.success));
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(visitControllerProvider) is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('زيارة جديدة', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العميل', style: AppTextStyles.caption),
                    const SizedBox(height: 4),
                    Text(widget.clientName ?? 'اختر عميل...', style: AppTextStyles.headingSmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('الإجراءات المطلوبة', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            AppCard(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _isCheckedIn ? AppColors.success.withOpacity(0.2) : AppColors.primaryLight,
                  child: Icon(Icons.location_on, color: _isCheckedIn ? AppColors.success : AppColors.primary),
                ),
                title: Text('تسجيل الموقع (Check-in)', style: AppTextStyles.bodyMainBold),
                trailing: _isCheckedIn 
                    ? const Icon(Icons.check_circle, color: AppColors.success)
                    : TextButton(onPressed: _checkIn, child: const Text('تسجيل الآن')),
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الصور المرفقة (${_photos.length})', style: AppTextStyles.bodyMainBold),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: AppColors.primary),
                          onPressed: _takePhoto,
                        ),
                      ],
                    ),
                    if (_photos.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length,
                          itemBuilder: (context, index) => Container(
                            width: 80,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _notesController,
              labelText: 'ملاحظات الزيارة',
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'إنهاء الزيارة',
              isLoading: isSaving,
              onPressed: _isCheckedIn ? _finishVisit : null, // Must check in first
            ),
          ],
        ),
      ),
    );
  }
}
