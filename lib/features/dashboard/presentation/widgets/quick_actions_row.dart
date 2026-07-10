import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_icon_button.dart';
import 'package:flowpay/l10n/app_localizations.dart';
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FlowIconButton(
          icon: Icons.qr_code,
          label: AppLocalizations.of(context)!.dashboardQuickActionPix,
          onTap: () {
            // TODO: Navigate to charges
          },
        ),
        FlowIconButton(
          icon: Icons.pix,
          label: 'Pix', // Usually brand names are not translated
          onTap: () {
            // TODO: Open Pix menu
          },
        ),
        FlowIconButton(
          icon: Icons.receipt_long,
          label: AppLocalizations.of(context)!.bottomNavTransactions,
          onTap: () {
            // TODO: Navigate to transactions
          },
        ),
        FlowIconButton(
          icon: Icons.fast_forward,
          label: AppLocalizations.of(context)!.dashboardQuickActionTransfer,
          onTap: () {
            // TODO: Open anticipation simulator
          },
        ),
      ],
    );
  }
}
