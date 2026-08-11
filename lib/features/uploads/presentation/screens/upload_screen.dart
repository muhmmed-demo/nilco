import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/router/app_router.dart';
import '../providers/uploads_provider.dart';

class UploadScreen extends ConsumerStatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final _noteController = TextEditingController();
  File? _image;
  String _selectedCategory = 'ألعاب الطاولة';
  final List<String> _categories = ['ألعاب الطاولة', 'ألعاب كروت', 'بازل', 'صلصال', 'بطاقات تعليمية', 'ألعاب حفلات'];
  Position? _currentPosition;
  bool _isFetchingLocation = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isFetchingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw Exception('Location services are disabled.');

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied.');
      }

      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = position;
        _isFetchingLocation = false;
      });
    } catch (e) {
      setState(() => _isFetchingLocation = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
      }
    }
  }

  void _submit() {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please_capture_image'.tr()), backgroundColor: AppColors.warning));
      return;
    }
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fetch GPS location'), backgroundColor: AppColors.warning));
      return;
    }

    ref.read(uploadControllerProvider.notifier).submitReport(
      _image!.path,
      _selectedCategory,
      _noteController.text,
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(uploadControllerProvider, (previous, next) {
      if (next is AsyncData && previous is AsyncLoading) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted successfully!'), backgroundColor: AppColors.success));
        context.pop();
        ref.refresh(galleryReportsProvider); // Refresh gallery
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString()), backgroundColor: AppColors.error));
      }
    });

    final uploadState = ref.watch(uploadControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('field_report'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => context.push(AppRouter.gallery),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: AppCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image Picker Area
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => SafeArea(
                        child: Wrap(
                          children: [
                            ListTile(leading: const Icon(Icons.camera_alt), title: const Text('Camera'), onTap: () { context.pop(); _pickImage(ImageSource.camera); }),
                            ListTile(leading: const Icon(Icons.photo), title: const Text('Gallery'), onTap: () { context.pop(); _pickImage(ImageSource.gallery); }),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 2),
                      image: _image != null ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover) : null,
                    ),
                    child: _image == null ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 48, color: AppColors.textSecondary),
                        SizedBox(height: 8),
                        Text('Tap to capture store shelf', style: TextStyle(color: AppColors.textSecondary)),
                      ],
                    ) : null,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Toy Category Dropdown
                const Text('Toy Category', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isExpanded: true,
                      dropdownColor: AppColors.surface,
                      items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(color: AppColors.textPrimary)))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // GPS Location
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _currentPosition != null 
                          ? '${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}'
                          : 'get_gps'.tr(),
                        style: AppTextStyles.bodySecondary,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: _isFetchingLocation 
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.location_on, color: AppColors.primary),
                      label: Text('get_gps'.tr(), style: const TextStyle(color: AppColors.primary)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                
                // Notes
                AppTextField(
                  controller: _noteController,
                  labelText: 'Observations / Notes',
                ),
                const SizedBox(height: 32),
                
                // Submit Button
                AppButton(
                  text: 'submit_report'.tr(),
                  isLoading: uploadState is AsyncLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
