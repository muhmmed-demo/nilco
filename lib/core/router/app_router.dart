import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Auth
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/auth/presentation/screens/phone_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

// Errors
import '../error/presentation/screens/disconnect_screen.dart';
import '../error/presentation/screens/unauthorized_screen.dart';

// Common/Old routes (keeping them just in case or for settings)
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

// --- NEW ERP ROUTES ---
// Rep
import '../../features/rep/home/home_screen.dart';
import '../../features/rep/route/route_screen.dart';
import '../../features/rep/visits/new_visit_screen.dart';
import '../../features/rep/visits/visit_history_screen.dart';
import '../../features/rep/orders/rep_orders_screen.dart';
import '../../features/rep/orders/new_order_screen.dart';
import '../../features/rep/stock/client_stock_screen.dart';
import '../../features/rep/performance/rep_performance_screen.dart';

// Manager
import '../../features/manager/home/home_screen.dart';
import '../../features/manager/reps/reps_screen.dart';
import '../../features/manager/routes/routes_screen.dart';
import '../../features/manager/orders/orders_screen.dart';
import '../../features/manager/reports/reports_screen.dart';

// Warehouse
import '../../features/warehouse/home/home_screen.dart';
import '../../features/warehouse/stock/stock_screen.dart';
import '../../features/warehouse/orders/orders_screen.dart';

class AppRouter {
  AppRouter._();

  // Shared
  static const String splash = '/';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String phoneVerification = '/phone-verification';
  static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String unauthorized = '/unauthorized';
  static const String disconnect = '/disconnect';

  // Old home (redirected dynamically now, but keeping constant if needed)
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      // Shared Auth & Utils
      GoRoute(path: splash, builder: (_, __) => const SplashScreen()),
      GoRoute(path: login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: signUp, builder: (_, __) => const SignUpScreen()),
      GoRoute(path: phoneVerification, builder: (_, __) => const PhoneVerificationScreen()),
      GoRoute(path: forgotPassword, builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(path: settings, builder: (_, __) => const SettingsScreen()),
      GoRoute(path: profile, builder: (_, __) => const ProfileScreen()),
      GoRoute(path: notifications, builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: unauthorized, builder: (_, __) => const UnauthorizedScreen()),
      GoRoute(path: disconnect, builder: (_, __) => const DisconnectScreen()),

      // --- REP ROUTES ---
      GoRoute(path: '/rep/home', builder: (_, __) => const RepHomeScreen()),
      GoRoute(path: '/rep/route', builder: (_, __) => const RepRouteScreen()),
      GoRoute(
        path: '/rep/visit/new', 
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return NewVisitScreen(
            clientId: extra?['clientId'],
            clientName: extra?['clientName'],
          );
        },
      ),
      GoRoute(path: '/rep/visits', builder: (_, __) => const VisitHistoryScreen()),
      GoRoute(path: '/rep/orders', builder: (_, __) => const RepOrdersScreen()),
      GoRoute(path: '/rep/order/new', builder: (_, __) => const NewOrderScreen()),
      GoRoute(path: '/rep/stock', builder: (_, __) => const ClientStockScreen()),
      GoRoute(path: '/rep/performance', builder: (_, __) => const RepPerformanceScreen()),

      // --- MANAGER ROUTES ---
      GoRoute(path: '/manager/home', builder: (_, __) => const ManagerHomeScreen()),
      GoRoute(path: '/manager/reps', builder: (_, __) => const RepsListScreen()),
      GoRoute(path: '/manager/routes', builder: (_, __) => const RoutesManagerScreen()),
      GoRoute(path: '/manager/orders', builder: (_, __) => const OrdersManagerScreen()),
      GoRoute(path: '/manager/reports', builder: (_, __) => const ReportsScreen()),

      // --- WAREHOUSE ROUTES ---
      GoRoute(path: '/warehouse/home', builder: (_, __) => const WarehouseHomeScreen()),
      GoRoute(path: '/warehouse/stock', builder: (_, __) => const StockManagementScreen()),
      GoRoute(path: '/warehouse/orders', builder: (_, __) => const IncomingOrdersScreen()),
    ],
  );
}
