import os

def replace_in_file(filepath, old_text, new_text):
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        return
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    new_content = content.replace(old_text, new_text)
    if content != new_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

# 1. Fix providers imports
providers = [
    'lib/features/dashboard/presentation/providers/dashboard_provider.dart',
    'lib/features/activity/presentation/providers/activity_provider.dart',
    'lib/features/training/presentation/providers/training_provider.dart',
    'lib/features/uploads/presentation/providers/uploads_provider.dart',
]
for p in providers:
    replace_in_file(p, "import '../data/", "import '../../data/")

# 2. Fix dashboard screens imports
replace_in_file('lib/features/dashboard/presentation/screens/home_dashboard_screen.dart', "import 'widgets/", "import '../widgets/")
replace_in_file('lib/features/dashboard/presentation/screens/statistics_screen.dart', "import 'widgets/", "import '../widgets/")

# 3. Fix easy_localization imports
l10n_files = [
    'lib/features/dashboard/presentation/screens/statistics_screen.dart',
    'lib/features/uploads/presentation/screens/upload_screen.dart',
    'lib/features/gamification/presentation/screens/celebration_screen.dart',
    'lib/core/error/presentation/screens/disconnect_screen.dart',
    'lib/core/error/presentation/screens/unauthorized_screen.dart',
]
import_stmt = "import 'package:easy_localization/easy_localization.dart';\n"
for filepath in l10n_files:
    if not os.path.exists(filepath): continue
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    if 'easy_localization' not in content:
        # insert after first line
        lines = content.split('\n')
        lines.insert(1, import_stmt.strip())
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write('\n'.join(lines))
        print(f"Added localization import to {filepath}")

# 4. Fix auth_controller.dart
replace_in_file(
    'lib/features/auth/presentation/providers/auth_controller.dart',
    'await _repository.resetPassword(email, code, newPassword);',
    'await _repository.resetPassword(newPassword, code);'
)
# And the signature of the method too
replace_in_file(
    'lib/features/auth/presentation/providers/auth_controller.dart',
    'Future<void> resetPassword(String email, String code, String newPassword) async {',
    'Future<void> resetPassword(String email, String code, String newPassword) async {' # wait, the controller can keep its signature, it just needs to pass arguments correctly to repo.
)

# 5. Fix app_theme.dart
replace_in_file(
    'lib/core/theme/app_theme.dart',
    'cardTheme: CardTheme(',
    'cardTheme: CardThemeData('
)

# 6. Fix app_router.dart placeholders
app_router = 'lib/core/router/app_router.dart'
with open(app_router, 'r', encoding='utf-8') as f:
    router_content = f.read()
if 'import \'../../features/placeholder_screens.dart\' as placeholders;' not in router_content:
    lines = router_content.split('\n')
    lines.insert(1, 'import \'../../features/placeholder_screens.dart\' as placeholders;')
    with open(app_router, 'w', encoding='utf-8') as f:
        f.write('\n'.join(lines))
    print("Fixed app_router.dart")

print("All fixes applied.")
