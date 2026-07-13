import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_icon_button.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlowIconButton(
          icon: Icons.pix,
          label: l10n.dashboardQuickActionTransfer,
          onTap: () => _showComingSoon(context, l10n),
        ),
        FlowIconButton(
          icon: Icons.bolt_rounded,
          label: l10n.dashboardQuickActionAnticipate,
          onTap: () => _showComingSoon(context, l10n),
        ),
        FlowIconButton(
          icon: Icons.payments_rounded,
          label: l10n.dashboardQuickActionPay,
          onTap: () => _showComingSoon(context, l10n),
        ),
        FlowIconButton(
          icon: Icons.link_rounded,
          label: l10n.dashboardQuickActionLink,
          onTap: () => _showComingSoon(context, l10n),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.comingSoon),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
