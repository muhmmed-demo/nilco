import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class RepBottomNav extends StatelessWidget {
  final int currentIndex;

  const RepBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/rep/home');
        break;
      case 1:
        context.go('/rep/route');
        break;
      case 2:
        context.go('/rep/orders');
        break;
      case 3:
        context.go('/rep/performance');
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'خط السير'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'الأداء'),
      ],
    );
  }
}
