import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(FlowSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 64, color: FlowColors.primary),
              SizedBox(height: FlowSpacing.md),
              Text(
                AppLocalizations.of(context)!.registerComingSoonTitle,
                style: FlowTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: FlowSpacing.sm),
              Text(
                AppLocalizations.of(context)!.registerComingSoonDesc,
                textAlign: TextAlign.center,
                style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
