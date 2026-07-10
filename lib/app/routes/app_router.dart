import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flowpay/shared/widgets/app_bottom_nav.dart';
import 'package:flowpay/features/auth/presentation/pages/splash_page.dart';
import 'package:flowpay/features/auth/presentation/pages/login_page.dart';
import 'package:flowpay/features/auth/presentation/pages/register_page.dart';
import 'package:flowpay/features/home/presentation/pages/home_page.dart';
import 'package:flowpay/features/transactions/presentation/pages/transactions_page.dart';
import 'package:flowpay/features/charges/presentation/pages/charges_page.dart';
import 'package:flowpay/features/profile/presentation/pages/profile_page.dart';

/// Global router key for context-less navigation if needed
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorTransactionsKey = GlobalKey<NavigatorState>(debugLabel: 'shellTransactions');
final GlobalKey<NavigatorState> _shellNavigatorChargesKey = GlobalKey<NavigatorState>(debugLabel: 'shellCharges');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    // Auth Guard
    final isGoingToSplash = state.matchedLocation == '/splash';
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToRegister = state.matchedLocation == '/register';
    
    // Check if user has an active Supabase session
    final hasSession = Supabase.instance.client.auth.currentSession != null;

    if (!hasSession && !isGoingToSplash && !isGoingToLogin && !isGoingToRegister) {
      return '/login';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppBottomNav(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0 - Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        
        // Branch 1 - Transactions
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTransactionsKey,
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsPage(),
            ),
          ],
        ),
        
        // Branch 2 - Charges
        StatefulShellBranch(
          navigatorKey: _shellNavigatorChargesKey,
          routes: [
            GoRoute(
              path: '/charges',
              builder: (context, state) => const ChargesPage(),
            ),
          ],
        ),
        
        // Branch 3 - Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
