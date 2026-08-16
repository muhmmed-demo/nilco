import os

build_gradle_path = 'android/app/build.gradle'
if os.path.exists(build_gradle_path):
    with open(build_gradle_path, 'r') as f:
        content = f.read()

    # Add coreLibraryDesugaringEnabled true
    if 'coreLibraryDesugaringEnabled true' not in content:
        content = content.replace(
            'compileOptions {',
            'compileOptions {\n        coreLibraryDesugaringEnabled true'
        )

    # Add dependency
    if 'coreLibraryDesugaring' not in content:
        content = content.replace(
            'dependencies {',
            "dependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'"
        )

    with open(build_gradle_path, 'w') as f:
        f.write(content)
    print("Patched android/app/build.gradle successfully for desugaring.")
else:
    print(f"Error: {build_gradle_path} not found.")
