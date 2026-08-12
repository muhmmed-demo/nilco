import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara"
rep_dir = os.path.join(base_dir, "lib", "features", "rep")

files = {}

# 1. rep_visits_provider.dart
os.makedirs(os.path.join(rep_dir, "visits", "providers"), exist_ok=True)
files[os.path.join(rep_dir, "visits", "providers", "rep_visits_provider.dart")] = """import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/visit_model.dart';
import '../../../../core/repositories/mock/mock_visits_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/providers/auth_state.dart';

final visitsRepositoryProvider = Provider((ref) => MockVisitsRepository());

final repVisitsProvider = FutureProvider<List<VisitModel>>((ref) async {
  final authState = ref.watch(authControllerProvider);
  if (authState is AuthAuthenticated) {
    final repo = ref.watch(visitsRepositoryProvider);
    return repo.getRepVisits(authState.user.id);
  }
  return [];
});

class VisitController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  VisitController(this.ref) : super(const AsyncData(null));

  Future<bool> createVisit(VisitModel visit) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(visitsRepositoryProvider);
      await repo.createVisit(visit);
      ref.invalidate(repVisitsProvider); // Refresh the list
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final visitControllerProvider = StateNotifierProvider<VisitController, AsyncValue<void>>((ref) {
  return VisitController(ref);
});
"""

# 2. route_screen.dart
files[os.path.join(rep_dir, "route", "route_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_button.dart';
import '../home/providers/rep_dashboard_provider.dart';
import '../home/widgets/rep_bottom_nav.dart';

class RepRouteScreen extends ConsumerWidget {
  const RepRouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAsync = ref.watch(todayRouteProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('خط سير اليوم', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: routeAsync.when(
        data: (route) {
          if (route == null || route.stops.isEmpty) {
            return const Center(child: Text('لا يوجد عملاء في خط السير اليوم.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: route.stops.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final stop = route.stops[index];
              return AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(stop.clientName, style: AppTextStyles.headingSmall),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(stop.address, style: AppTextStyles.caption),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: stop.isVisited ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              stop.isVisited ? 'تمت الزيارة' : 'قيد الانتظار',
                              style: AppTextStyles.caption.copyWith(
                                color: stop.isVisited ? AppColors.success : AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      if (!stop.isVisited) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: 'بدء الزيارة',
                            onPressed: () {
                              context.push('/rep/visit/new', extra: {
                                'clientId': stop.clientId,
                                'clientName': stop.clientName,
                              });
                            },
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideX();
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      bottomNavigationBar: const RepBottomNav(currentIndex: 1),
    );
  }
}
"""

# 3. new_visit_screen.dart
files[os.path.join(rep_dir, "visits", "new_visit_screen.dart")] = """import 'package:flutter/material.dart';
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
      _photos.add('mock_photo_url_\\${_photos.length}');
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
"""

# 4. visit_history_screen.dart
files[os.path.join(rep_dir, "visits", "visit_history_screen.dart")] = """import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import 'providers/rep_visits_provider.dart';

class VisitHistoryScreen extends ConsumerWidget {
  const VisitHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visitsAsync = ref.watch(repVisitsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('سجل الزيارات', style: AppTextStyles.headingMedium.copyWith(color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: visitsAsync.when(
        data: (visits) {
          if (visits.isEmpty) {
            return const Center(child: Text('لا توجد زيارات سابقة.'));
          }
          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
          
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: visits.length,
            itemBuilder: (context, index) {
              final visit = visits[index];
              return AppCard(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(visit.clientName, style: AppTextStyles.headingSmall),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('مكتملة', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(dateFormat.format(visit.completedAt ?? visit.scheduledAt), style: AppTextStyles.caption),
                        ],
                      ),
                      if (visit.notes != null && visit.notes!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(visit.notes!, style: AppTextStyles.bodySecondary),
                        )
                      ],
                      if (visit.photoUrls.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.photo_library, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text('${visit.photoUrls.length} صور مرفقة', style: AppTextStyles.caption.copyWith(color: AppColors.primary)),
                          ],
                        )
                      ]
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 100 * index)).slideY(begin: 0.1);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
"""

for filepath, content in files.items():
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)

print("Phase 4 Rep Route & Visits generated.")
