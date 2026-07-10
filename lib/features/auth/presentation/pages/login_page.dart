import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_state.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/app/theme/app_spacing.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/core/bloc/locale_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  int _tapCount = 0;
  DateTime? _lastTap;

  void _login() {
    context.read<AuthCubit>().login(
      _emailController.text,
      _passwordController.text,
    );
  }

  void _handleLogoTap() {
    final now = DateTime.now();
    if (_lastTap == null || now.difference(_lastTap!) > const Duration(seconds: 1)) {
      _tapCount = 1;
    } else {
      _tapCount++;
    }
    _lastTap = now;

    if (_tapCount >= 3) {
      _tapCount = 0;
      _emailController.text = 'demo@flowpay.com';
      _passwordController.text = 'FlowPayDemo2026!';
      _login();
    }
  }

  void _loginGoogle() {
    context.read<AuthCubit>().loginWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        // Adding a subtle gradient background for the premium feel
        body: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.8, -0.6),
              radius: 1.5,
              colors: [
                Color(0xFF1E2433), // Slightly lighter at top left
                AppColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _handleLogoTap,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Glassmorphism Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1D27).withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.loginTitle,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.loginEmailLabel,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.loginPasswordLabel,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return ElevatedButton(
                                    onPressed: isLoading ? null : _login,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : Text(AppLocalizations.of(context)!.loginButton),
                                  );
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              
                              // Google Login Button
                              OutlinedButton.icon(
                                onPressed: _loginGoogle,
                                icon: const Icon(Icons.login),
                                label: Text(AppLocalizations.of(context)!.loginGoogleButton),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              TextButton(
                                onPressed: () => context.push('/register'),
                                child: Text(
                                  AppLocalizations.of(context)!.loginRegisterPrompt,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.md,
              right: AppSpacing.md,
              child: IconButton(
                icon: const Icon(Icons.language),
                onPressed: () {
                  context.read<LocaleCubit>().toggleLocale();
                },
                tooltip: 'Change Language / Mudar Idioma',
              ),
            ),
          ],
        ),
      ),
    ),
    ),
    );
  }
}

