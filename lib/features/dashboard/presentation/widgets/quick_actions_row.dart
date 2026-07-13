import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/components/buttons/flow_icon_button.dart';
import 'package:flowpay/l10n/app_localizations.dart';
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FlowIconButton(
          icon: Icons.pix,
          label: 'Transferir',
          onTap: () => _showComingSoon(context),
        ),
        FlowIconButton(
          icon: Icons.bolt_rounded,
          label: 'Antecipar',
          onTap: () => _showComingSoon(context),
        ),
        FlowIconButton(
          icon: Icons.payments_rounded,
          label: 'Pagar',
          onTap: () => _showComingSoon(context),
        ),
        FlowIconButton(
          icon: Icons.link_rounded,
          label: 'Criar Link',
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Em breve!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
