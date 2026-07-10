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
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color? valueColor;
  final VoidCallback onTap;

  const FlowListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.onTap,
    this.value,
    this.trailingText,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await FlowHaptics.lightImpact();
        onTap();
      },
      contentPadding: const EdgeInsets.symmetric(
        horizontal: FlowSpacing.md,
        vertical: FlowSpacing.xs,
      ),
      leading: CircleAvatar(
        backgroundColor: iconBackgroundColor,
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
      title: Text(
        title,
        style: FlowTypography.moneySmall.copyWith(
          color: valueColor ?? FlowColors.textPrimary,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: FlowTypography.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText!,
              style: FlowTypography.bodySmall,
            ),
          if (trailingText != null) const SizedBox(width: FlowSpacing.sm),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade700,
            size: 20,
          ),
        ],
      ),
    );
  }
}
