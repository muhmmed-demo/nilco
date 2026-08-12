import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'widgets/greeting_section.dart';
import 'widgets/performance_cards.dart';
import 'widgets/today_route_preview.dart';
import 'widgets/quick_actions.dart';
import 'widgets/rep_bottom_nav.dart';

class RepHomeScreen extends StatelessWidget {
  const RepHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingSection().animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              const PerformanceCards(),
              const SizedBox(height: 24),
              const QuickActions().animate().slideX(begin: 0.1, duration: 400.ms).fadeIn(),
              const SizedBox(height: 24),
              const TodayRoutePreview().animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const RepBottomNav(currentIndex: 0),
    );
  }
}
