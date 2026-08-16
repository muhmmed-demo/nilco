import os

def patch_groovy(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. compileOptions
    if 'coreLibraryDesugaringEnabled true' not in content:
        if 'compileOptions {' in content:
            content = content.replace(
                'compileOptions {',
                'compileOptions {\n        coreLibraryDesugaringEnabled true'
            )
        elif 'android {' in content:
            content = content.replace(
                'android {',
                'android {\n    compileOptions {\n        coreLibraryDesugaringEnabled true\n        sourceCompatibility JavaVersion.VERSION_1_8\n        targetCompatibility JavaVersion.VERSION_1_8\n    }'
            )

    # 2. dependencies
    if 'coreLibraryDesugaring' not in content:
        if 'dependencies {' in content:
            content = content.replace(
                'dependencies {',
                "dependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'"
            )
        else:
            content += "\n\ndependencies {\n    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.0.4'\n}\n"

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Successfully patched Groovy gradle: {path}")

def patch_kotlin_dsl(path):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    if 'isCoreLibraryDesugaringEnabled' not in content:
        if 'compileOptions {' in content:
            content = content.replace(
                'compileOptions {',
                'compileOptions {\n        isCoreLibraryDesugaringEnabled = true'
            )
        elif 'android {' in content:
            content = content.replace(
                'android {',
                'android {\n    compileOptions {\n        isCoreLibraryDesugaringEnabled = true\n    }'
            )

    if 'coreLibraryDesugaring' not in content:
        if 'dependencies {' in content:
            content = content.replace(
                'dependencies {',
                'dependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")'
            )
        else:
            content += '\n\ndependencies {\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")\n}\n'

    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Successfully patched Kotlin DSL gradle: {path}")

def main():
    groovy_path = 'android/app/build.gradle'
    kotlin_path = 'android/app/build.gradle.kts'

    if os.path.exists(groovy_path):
        patch_groovy(groovy_path)
    elif os.path.exists(kotlin_path):
        patch_kotlin_dsl(kotlin_path)
    else:
        print("Warning: Neither android/app/build.gradle nor build.gradle.kts found!")

if __name__ == '__main__':
    main()
