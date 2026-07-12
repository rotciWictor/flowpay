import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_state.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/features/auth/presentation/widgets/gradient_circular_progress_indicator.dart';
import 'package:flowpay/shared/design_system/components/layout/flow_background.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Add a small artificial delay so the splash screen doesn't just flash
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    context.read<AuthCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/');
        } else if (state is AuthUnauthenticated || state is AuthError) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FlowBackground(
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
              ),
              const SizedBox(height: FlowSpacing.xxl),
              const GradientCircularProgressIndicator(
                radius: 20,
                strokeWidth: 4,
                gradientColors: [
                  FlowColors.primary,
                  FlowColors.primaryGradientEnd,
                  FlowColors.primary,
                ],
              ),
            ],
          ),
        ),
        ), // Fechando o FlowBackground
      ),
    );
  }
}
