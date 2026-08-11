import 'package:easy_localization/easy_localization.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.email_required'.tr();
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'validation.email_invalid'.tr();
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required'.tr();
    }
    if (value.length < 8) {
      return 'validation.password_too_short'.tr();
    }
    return null;
  }

  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'validation.confirm_password_required'.tr();
    }
    if (value != originalPassword) {
      return 'validation.passwords_do_not_match'.tr();
    }
    return null;
  }

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'validation.field_required'.tr(args: [fieldName]);
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.phone_required'.tr();
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,14}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'validation.phone_invalid'.tr();
    }
    return null;
  }
}
