import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ManagerBottomNav extends StatelessWidget {
  final int currentIndex;

  const ManagerBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/manager/home');
        break;
      case 1:
        context.go('/manager/orders');
        break;
      case 2:
        context.go('/manager/reps');
        break;
      case 3:
        context.go('/manager/reports');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(index, context),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'المناديب'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'التقارير'),
      ],
    );
  }
}
