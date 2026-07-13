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
    
    // Mocks melhorados com contexto real
    final mockSales = [
      {
        'title': 'Link #1002 - João Silva',
        'subtitle': 'Vence em 2 dias',
        'value': 'R\$ 150.50',
        'icon': Icons.link_rounded,
        'color': FlowColors.warning,
        'bgColor': FlowColors.statusPendingBg,
      },
      {
        'title': 'Link #1012 - Maria Souza',
        'subtitle': 'Vencido há 1 dia',
        'value': 'R\$ 301.00',
        'icon': Icons.warning_rounded,
        'color': FlowColors.error,
        'bgColor': FlowColors.statusDeclinedBg,
      },
      {
        'title': 'Boleto #1022 - Loja XPTO',
        'subtitle': 'Vence hoje',
        'value': 'R\$ 451.50',
        'icon': Icons.receipt_long_rounded,
        'color': FlowColors.warning,
        'bgColor': FlowColors.statusPendingBg,
      },
    ];

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.charges, // "Vender"
                        style: FlowTypography.headlineMedium.copyWith(color: FlowColors.textPrimary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline, color: FlowColors.textSecondary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: FlowSpacing.xs),
                  Text(
                    l10n.chargesHowToSell, 
                    style: FlowTypography.bodyLarge.copyWith(color: FlowColors.textSecondary),
                  ),
                  const SizedBox(height: FlowSpacing.xl),
                  
                  // AÇÃO PRIMÁRIA: Link de Pagamento (Full Width)
                  FlowCard(
                    onTap: () {
                      // TODO: Navegar para criação de Link
                    },
                    padding: const EdgeInsets.all(FlowSpacing.lg),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(FlowSpacing.md),
                          decoration: BoxDecoration(
                            color: FlowColors.primary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.link_rounded, color: FlowColors.primary, size: 32),
                        ),
                        const SizedBox(width: FlowSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.chargesPaymentLink,
                                style: FlowTypography.bodyLarge.copyWith(
                                  color: FlowColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: FlowSpacing.xxs),
                              Text(
                                l10n.chargesPaymentLinkDesc,
                                style: FlowTypography.bodySmall.copyWith(
                                  color: FlowColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: FlowColors.textSecondary),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: FlowSpacing.lg),

                  // AÇÕES SECUNDÁRIAS: Pix, Tap to Pay, Boleto, Assinatura (Grid 2x2)
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: FlowSpacing.md,
                    crossAxisSpacing: FlowSpacing.md,
                    childAspectRatio: 1.5, // Aspect ratio ajustado para cards mais horizontais
                    children: [
                      _SalesActionCard(
                        title: l10n.paymentMethodPix, 
                        icon: Icons.pix,
                        color: FlowColors.brandPix,
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                      _SalesActionCard(
                        title: l10n.chargesTapToPay,
                        icon: Icons.contactless_outlined,
                        color: FlowColors.primaryGradientEnd,
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                      _SalesActionCard(
                        title: l10n.chargesBoleto,
                        icon: Icons.description_rounded,
                        color: FlowColors.textSecondary,
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                      _SalesActionCard(
                        title: l10n.chargesSubscription, 
                        icon: Icons.autorenew_rounded,
                        color: FlowColors.info,
                        onTap: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                          );
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: FlowSpacing.xxl),
                  
                  // VENDAS PENDENTES (Com Badge)
                  Row(
                    children: [
                      Text(
                        l10n.chargesPendingSales,
                        style: FlowTypography.titleMedium.copyWith(color: FlowColors.textPrimary),
                      ),
                      const SizedBox(width: FlowSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: FlowColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
                        ),
                        child: Text(
                          '3',
                          style: FlowTypography.bodySmall.copyWith(
                            color: FlowColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                        );
                      },
                        child: Text(
                          l10n.chargesSeeAll,
                          style: FlowTypography.bodySmall.copyWith(color: FlowColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FlowSpacing.xs),
                ],
              ),
            ),
          ),
          
          // MOCK LIST (Com dados realistas)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sale = mockSales[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.md, vertical: FlowSpacing.xs),
                  child: FlowListTile(
                    title: sale['title'] as String,
                    subtitle: sale['subtitle'] as String,
                    trailingText: sale['value'] as String,
                    icon: sale['icon'] as IconData,
                    iconColor: sale['color'] as Color,
                    iconBackgroundColor: sale['bgColor'] as Color,
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.comingSoon), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                );
              },
              childCount: mockSales.length,
            ),
          ),
          
          const SliverToBoxAdapter(
            child: SizedBox(height: FlowSpacing.xxl * 2), // Ajustado o bottom padding
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
      padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.sm, vertical: FlowSpacing.sm),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(FlowSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: FlowSpacing.xs),
          Expanded(
            child: Text(
              title,
              style: FlowTypography.bodyMedium.copyWith(
                color: FlowColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
