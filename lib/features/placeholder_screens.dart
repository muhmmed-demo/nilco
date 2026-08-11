import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

// 1. Splash Screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Splash Screen');
}

// 2. Onboarding
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Onboarding');
}

// 3. Login
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Login');
}

// 4. Sign Up
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Sign Up');
}

// 5. Phone Verification
class PhoneVerificationScreen extends StatelessWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Phone Verification');
}

// 6. Forgot Password
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Forgot Password');
}

// 7. Home Dashboard
class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Home / Performance');
}

// 8. Statistics
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Statistics');
}

// 9. Activity
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Activity');
}

// 10. Training
class TrainingScreen extends StatelessWidget {
  const TrainingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Training');
}

// 11. Upload / Report
class UploadScreen extends StatelessWidget {
  const UploadScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Upload/Report');
}

// 12. Uploaded Images Gallery
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Gallery');
}

// 13. Archive
class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Archive');
}

// 14. Celebration Modal/Screen
class CelebrationScreen extends StatelessWidget {
  const CelebrationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Celebration');
}

// 15. Notifications
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Notifications');
}

// 16. Profile
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Profile');
}

// 17. Unauthorized
class UnauthorizedScreen extends StatelessWidget {
  const UnauthorizedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Unauthorized');
}

// 18. Disconnect
class DisconnectScreen extends StatelessWidget {
  const DisconnectScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Disconnected');
}

// 19. Settings
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const PlaceholderScreen(title: 'Settings');
}
