import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/l10n/app_localizations.dart';

import 'package:flowpay/shared/design_system/components/layout/flow_background.dart';

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
      backgroundColor: Colors.transparent,
      // The body is the current branch of the StatefulShellRoute
      body: FlowBackground(
        child: navigationShell,
      ),
      extendBody: true, // Crucial to make the glass effect visible over the content
      bottomNavigationBar: ClipRRect(
        // ClipRRect prevents the blur from bleeding outside the nav bar
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: FlowColors.surface.withValues(alpha: 0.6), // 60% opacity surface
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
              selectedItemColor: FlowColors.primary,
              unselectedItemColor: FlowColors.textSecondary,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home_rounded),
                  label: AppLocalizations.of(context)!.bottomNavHome,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.receipt_long_outlined),
                  activeIcon: const Icon(Icons.receipt_long_rounded),
                  label: AppLocalizations.of(context)!.bottomNavTransactions,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.point_of_sale_outlined),
                  activeIcon: const Icon(Icons.point_of_sale_rounded),
                  label: AppLocalizations.of(context)!.bottomNavCharges,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person_rounded),
                  label: AppLocalizations.of(context)!.bottomNavProfile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
