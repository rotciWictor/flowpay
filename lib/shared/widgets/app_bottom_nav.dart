import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/app/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppBottomNav({
    super.key,
    required this.navigationShell,
  });

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      // Support navigating to the initial location when tapping the active tab.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is the current branch of the StatefulShellRoute
      body: navigationShell,
      extendBody: true, // Crucial to make the glass effect visible over the content
      bottomNavigationBar: ClipRRect(
        // ClipRRect prevents the blur from bleeding outside the nav bar
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6), // 60% opacity surface
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1), // 10% white border
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.transparent, // Let the glass container show through
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Transações',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.qr_code_2_outlined),
                  activeIcon: Icon(Icons.qr_code_2_rounded),
                  label: 'Cobrar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Perfil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
