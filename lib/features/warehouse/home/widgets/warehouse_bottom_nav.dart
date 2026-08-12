import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class WarehouseBottomNav extends StatelessWidget {
  final int currentIndex;

  const WarehouseBottomNav({Key? key, required this.currentIndex}) : super(key: key);

  void _onItemTapped(int index, BuildContext context) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/warehouse/home');
        break;
      case 1:
        context.go('/warehouse/orders');
        break;
      case 2:
        context.go('/warehouse/stock');
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
        BottomNavigationBarItem(icon: Icon(Icons.move_to_inbox), label: 'الطلبيات'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'المخزون'),
      ],
    );
  }
}
