import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/behavior/flow_haptics.dart';

/// FlowListTile
///
/// Item de lista padronizado para extratos e listagens.
/// Incorpora ícones com background (Avatar), valores monetários destacados e setas indicativas.
class FlowListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? value;
  final String? trailingText;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? valueColor;
  final VoidCallback onTap;
  
  // Custom slots for advanced usage (e.g. Card Brand icons or custom trailing badges)
  final Widget? leadingWidget;
  final Widget? trailingWidget;

  const FlowListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    this.value,
    this.trailingText,
    this.valueColor,
    this.leadingWidget,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await FlowHaptics.lightImpact();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: FlowSpacing.md,
            vertical: FlowSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leadingWidget ??
                  CircleAvatar(
                    backgroundColor: iconBackgroundColor ?? FlowColors.surface,
                    child: Icon(
                      icon ?? Icons.circle,
                      color: iconColor ?? FlowColors.primary,
                    ),
                  ),
              const SizedBox(width: FlowSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: FlowTypography.moneySmall.copyWith(
                        color: FlowColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: FlowTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FlowSpacing.sm),
              trailingWidget ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (trailingText != null)
                        Text(
                          trailingText!,
                          style: FlowTypography.moneySmall.copyWith(
                            color: valueColor ?? FlowColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                      if (trailingText != null) const SizedBox(width: FlowSpacing.sm),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
