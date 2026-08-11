import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/phone_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/home_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/statistics_screen.dart';
import '../../features/activity/presentation/screens/activity_screen.dart';
import '../../features/training/presentation/screens/training_screen.dart';
import '../../features/uploads/presentation/screens/upload_screen.dart';
import '../../features/uploads/presentation/screens/gallery_screen.dart';
import '../../features/archive/presentation/screens/archive_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/gamification/presentation/screens/celebration_screen.dart';
import '../error/presentation/screens/disconnect_screen.dart';
import '../error/presentation/screens/unauthorized_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String phoneVerification = '/phone-verification';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String statistics = '/statistics';
  static const String activity = '/activity';
  static const String training = '/training';
  static const String upload = '/upload';
  static const String gallery = '/gallery';
  static const String archive = '/archive';
  static const String celebration = '/celebration';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String unauthorized = '/unauthorized';
  static const String disconnect = '/disconnect';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: phoneVerification,
        builder: (context, state) => const PhoneVerificationScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomeDashboardScreen(),
      ),
      GoRoute(
        path: statistics,
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: activity,
        builder: (context, state) => const ActivityScreen(),
      ),
      GoRoute(
        path: training,
        builder: (context, state) => const TrainingScreen(),
      ),
      GoRoute(
        path: upload,
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: gallery,
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        path: archive,
        builder: (context, state) => const ArchiveScreen(),
      ),
      GoRoute(
        path: celebration,
        builder: (context, state) => const CelebrationScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: unauthorized,
        builder: (context, state) => const UnauthorizedScreen(),
      ),
      GoRoute(
        path: disconnect,
        builder: (context, state) => const DisconnectScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
