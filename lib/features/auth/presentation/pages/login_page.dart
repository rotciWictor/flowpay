import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_state.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/core/bloc/locale_cubit.dart';
import 'package:country_flags/country_flags.dart';

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
              backgroundColor: FlowColors.error,
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
                FlowColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(FlowSpacing.xl),
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
                    const SizedBox(height: FlowSpacing.xxl),
                    
                    // Glassmorphism Card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(FlowSpacing.xl),
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
                              const SizedBox(height: FlowSpacing.xl),
                              
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.loginEmailLabel,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: FlowSpacing.md),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.loginPasswordLabel,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                ),
                              ),
                              const SizedBox(height: FlowSpacing.xl),
                              
                              BlocBuilder<AuthCubit, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return Container(
                                    // Outer Container acts as the Gradient Border
                                    padding: const EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      gradient: const LinearGradient(
                                        colors: [FlowColors.primary, FlowColors.primaryGradientEnd],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: FlowColors.primary.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      // Inner Container is the dark body of the Ghost Button
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12.5),
                                        color: const Color(0xFF1A1D27).withValues(alpha: 0.95),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: isLoading ? null : _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                        child: isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              )
                                            : Text(
                                                AppLocalizations.of(context)!.loginButton,
                                                style: FlowTypography.labelLarge.copyWith(
                                                  fontSize: 16,
                                                  letterSpacing: 1.0,
                                                  color: FlowColors.textPrimary,
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: FlowSpacing.md),
                              
                              // Google Login Button
                              OutlinedButton.icon(
                                onPressed: _loginGoogle,
                                icon: const Icon(Icons.login),
                                label: Text(AppLocalizations.of(context)!.loginGoogleButton),
                              ),
                              const SizedBox(height: FlowSpacing.md),
                              TextButton(
                                onPressed: () => context.push('/register'),
                                child: Text(
                                  AppLocalizations.of(context)!.loginRegisterPrompt,
                                  style: FlowTypography.labelMedium.copyWith(
                                    color: FlowColors.textSecondary,
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
              top: FlowSpacing.md,
              right: FlowSpacing.md,
              child: IconButton(
                icon: BlocBuilder<LocaleCubit, Locale>(
                  builder: (context, locale) {
                    return CountryFlag.fromCountryCode(
                      locale.languageCode == 'pt' ? 'US' : 'BR',
                      theme: const ImageTheme(
                        shape: Circle(),
                        width: 24,
                        height: 24,
                      ),
                    );
                  },
                ),
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

