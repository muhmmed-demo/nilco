import os

base_dir = r"c:\Users\muhmm\OneDrive\Desktop\نيلكو\saytara\lib"

def replace_in_file(filepath, old_str, new_str):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    content = content.replace(old_str, new_str)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

# Fix app_text_styles.dart
text_styles_path = os.path.join(base_dir, "core", "theme", "app_text_styles.dart")
with open(text_styles_path, 'r', encoding='utf-8') as f:
    text_styles = f.read()
if 'headingMedium' not in text_styles:
    text_styles = text_styles.replace('}', """
  static const TextStyle headingMedium = TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static const TextStyle headingSmall = TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static const TextStyle caption = TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static const TextStyle bodyMainBold = TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );
}""")
with open(text_styles_path, 'w', encoding='utf-8') as f:
    f.write(text_styles)

# Fix app_colors.dart
colors_path = os.path.join(base_dir, "core", "theme", "app_colors.dart")
with open(colors_path, 'r', encoding='utf-8') as f:
    colors = f.read()
if 'primaryLight' not in colors:
    colors = colors.replace('static const Color primaryDark', """static const Color primaryDark = Color(0xFF0077A8);
  static const Color primaryLight = Color(0xFF4AC4FF);
  static const Color secondary = Color(0xFF2E86AB);""")
with open(colors_path, 'w', encoding='utf-8') as f:
    f.write(colors)

# Fix app_card.dart
card_path = os.path.join(base_dir, "core", "widgets", "app_card.dart")
with open(card_path, 'r', encoding='utf-8') as f:
    card = f.read()
if 'final EdgeInsetsGeometry? margin;' not in card:
    card = card.replace('final EdgeInsetsGeometry padding;', 'final EdgeInsetsGeometry padding;\n  final EdgeInsetsGeometry? margin;')
    card = card.replace('this.padding = const EdgeInsets.all(16.0),', 'this.padding = const EdgeInsets.all(16.0),\n    this.margin,')
    card = card.replace('margin: EdgeInsets.zero,', 'margin: margin ?? EdgeInsets.zero,')
with open(card_path, 'w', encoding='utf-8') as f:
    f.write(card)

# Fix app_text_field.dart
textfield_path = os.path.join(base_dir, "core", "widgets", "app_text_field.dart")
with open(textfield_path, 'r', encoding='utf-8') as f:
    textfield = f.read()
if 'final int? maxLines;' not in textfield:
    textfield = textfield.replace('final String? Function(String?)? validator;', 'final String? Function(String?)? validator;\n  final int? maxLines;')
    textfield = textfield.replace('this.validator,', 'this.validator,\n    this.maxLines = 1,')
    textfield = textfield.replace('keyboardType: keyboardType,', 'keyboardType: keyboardType,\n      maxLines: maxLines,')
with open(textfield_path, 'w', encoding='utf-8') as f:
    f.write(textfield)

# Fix imports
auth_state_path = os.path.join(base_dir, "features", "auth", "presentation", "providers", "auth_state.dart")
replace_in_file(auth_state_path, "import '../../core/models/user_model.dart';", "import '../../../../core/models/user_model.dart';")

auth_repo_path = os.path.join(base_dir, "features", "auth", "data", "auth_repository.dart")
replace_in_file(auth_repo_path, "import '../../core/models/user_model.dart';", "import '../../../../core/models/user_model.dart';")

auth_repo_impl_path = os.path.join(base_dir, "features", "auth", "data", "auth_repository_impl.dart")
replace_in_file(auth_repo_impl_path, "import '../../core/models/user_model.dart';", "import '../../../../core/models/user_model.dart';")
replace_in_file(auth_repo_impl_path, "import '../../core/mock/mock_data.dart';", "import '../../../../core/mock/mock_data.dart';")

auth_controller_path = os.path.join(base_dir, "features", "auth", "presentation", "providers", "auth_controller.dart")
replace_in_file(auth_controller_path, "import 'auth_state.dart';", "import 'auth_state.dart';\nimport '../../../../core/models/user_model.dart';")

new_visit_path = os.path.join(base_dir, "features", "rep", "visits", "new_visit_screen.dart")
replace_in_file(new_visit_path, "import '../../../auth/presentation/providers/auth_controller.dart';", "import '../../auth/presentation/providers/auth_controller.dart';")
replace_in_file(new_visit_path, "import '../../../auth/presentation/providers/auth_state.dart';", "import '../../auth/presentation/providers/auth_state.dart';")

print("Fixes applied successfully.")
