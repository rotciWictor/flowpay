import 'package:flutter/material.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/cards/flow_card.dart';
import 'package:flowpay/shared/design_system/components/lists/flow_list_tile.dart';

class ChargesPage extends StatelessWidget {
  const ChargesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(FlowSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: FlowSpacing.md),
                  Text(
                    l10n.charges, // Traduzido para "Vender" em pt_BR
                    style: FlowTypography.headlineMedium.copyWith(color: FlowColors.textPrimary),
                  ),
                  const SizedBox(height: FlowSpacing.xs),
                  Text(
                    // TODO: i18n
                    "Como você quer vender hoje?", 
                    style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textSecondary),
                  ),
                  const SizedBox(height: FlowSpacing.xl),
                  
                  // GRID 2x2
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: FlowSpacing.md,
                    crossAxisSpacing: FlowSpacing.md,
                    childAspectRatio: 1.1,
                    children: [
                      _SalesActionCard(
                        // TODO: i18n
                        title: 'Vender via Pix', 
                        icon: Icons.pix,
                        color: FlowColors.brandPix,
                        onTap: () {
                          // TODO: Navegar para geração de QR Code Pix
                        },
                      ),
                      _SalesActionCard(
                        title: 'Link de Pagamento',
                        icon: Icons.link_rounded,
                        color: FlowColors.primaryGradientEnd,
                        onTap: () {
                          // TODO: Navegar para criação de Link
                        },
                      ),
                      _SalesActionCard(
                        title: 'Boleto Bancário',
                        icon: Icons.qr_code_2_rounded,
                        color: FlowColors.textSecondary,
                        onTap: () {},
                      ),
                      _SalesActionCard(
                        title: 'Tap to Pay',
                        icon: Icons.contactless_outlined,
                        color: FlowColors.primary,
                        onTap: () {},
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: FlowSpacing.xxl),
                  Text(
                    // TODO: i18n
                    "Vendas Pendentes",
                    style: FlowTypography.titleMedium.copyWith(color: FlowColors.warning),
                  ),
                  const SizedBox(height: FlowSpacing.md),
                ],
              ),
            ),
          ),
          
          // MOCK LIST
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md, vertical: FlowSpacing.xs),
                  child: FlowListTile(
                    title: 'Link de Pagamento #10${index}2',
                    subtitle: 'Criado em 12/07/2026',
                    trailingText: 'R\$ ${((index + 1) * 150.50).toStringAsFixed(2)}',
                    icon: Icons.schedule_rounded,
                    iconColor: FlowColors.warning,
                    iconBackgroundColor: FlowColors.statusPendingBg,
                    onTap: () {},
                  ),
                );
              },
              childCount: 3,
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: FlowSpacing.xxl * 2),
          ),
        ],
      ),
    );
  }
}

class _SalesActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SalesActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlowCard(
      padding: const EdgeInsets.all(FlowSpacing.md),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(FlowSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: FlowSpacing.md),
          Text(
            title,
            style: FlowTypography.bodyMedium.copyWith(
              color: FlowColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
