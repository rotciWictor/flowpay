import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_state.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/components/cards/flow_card.dart';
import 'package:flowpay/core/bloc/locale_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = context.watch<AuthCubit>().state;
    final currentLocale = context.watch<LocaleCubit>().state;

    // Dados do merchant logado (ou fallback para mock)
    final merchant = authState is AuthAuthenticated
        ? authState.merchant
        : const Merchant(
            id: 'mock',
            email: 'lojista@flowpay.com',
            handle: '@lojademo',
            businessName: 'Loja Demo LTDA',
            document: '12.345.678/0001-99',
            segment: MerchantSegment.retail,
          );

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
                    l10n.profileTitle,
                    style: FlowTypography.headlineMedium.copyWith(color: FlowColors.textPrimary),
                  ),
                  const SizedBox(height: FlowSpacing.xl),

                  // =====================================================
                  // HEADER: Avatar + Info do Merchant
                  // =====================================================
                  FlowCard(
                    padding: const EdgeInsets.all(FlowSpacing.lg),
                    child: Row(
                      children: [
                        // Avatar com iniciais
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: FlowColors.primary.withValues(alpha: 0.15),
                          child: Text(
                            _getInitials(merchant.businessName),
                            style: FlowTypography.headlineMedium.copyWith(
                              color: FlowColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: FlowSpacing.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                merchant.businessName,
                                style: FlowTypography.titleLarge.copyWith(
                                  color: FlowColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: FlowSpacing.xxs),
                              Text(
                                merchant.handle,
                                style: FlowTypography.bodySmall.copyWith(
                                  color: FlowColors.primary,
                                ),
                              ),
                              const SizedBox(height: FlowSpacing.xxs),
                              Text(
                                merchant.email,
                                style: FlowTypography.bodySmall.copyWith(
                                  color: FlowColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: FlowColors.textSecondary, size: 20),
                      ],
                    ),
                    onTap: () {
                      // TODO: Navegar para Editar Perfil
                    },
                  ),

                  const SizedBox(height: FlowSpacing.xxl),

                  // =====================================================
                  // SEÇÃO: Minha Conta
                  // =====================================================
                  _SectionTitle(title: 'Minha Conta'),
                  const SizedBox(height: FlowSpacing.sm),
                  _ProfileMenuItem(
                    icon: Icons.store_rounded,
                    title: 'Dados do Negócio',
                    subtitle: _getSegmentLabel(merchant.segment),
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.badge_rounded,
                    title: 'Documento (CNPJ)',
                    subtitle: merchant.document,
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.security_rounded,
                    title: 'Segurança e Senha',
                    subtitle: 'Alterar senha, 2FA',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),

                  const SizedBox(height: FlowSpacing.xxl),

                  // =====================================================
                  // SEÇÃO: Financeiro
                  // =====================================================
                  _SectionTitle(title: 'Financeiro'),
                  const SizedBox(height: FlowSpacing.sm),
                  _ProfileMenuItem(
                    icon: Icons.percent_rounded,
                    title: 'Tabela de Taxas',
                    subtitle: 'Pix, Link, Boleto, Tap to Pay',
                    iconColor: FlowColors.warning,
                    onTap: () {
                      _showFeeTable(context);
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.account_balance_rounded,
                    title: 'Conta Bancária',
                    subtitle: 'Dados para recebimento',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.receipt_long_rounded,
                    title: 'Dados Fiscais',
                    subtitle: 'Nota fiscal e configuração',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),

                  const SizedBox(height: FlowSpacing.xxl),

                  // =====================================================
                  // SEÇÃO: Configurações
                  // =====================================================
                  _SectionTitle(title: 'Configurações'),
                  const SizedBox(height: FlowSpacing.sm),
                  _ProfileMenuItem(
                    icon: Icons.language_rounded,
                    title: 'Idioma',
                    subtitle: currentLocale.languageCode == 'pt' ? 'Português (BR)' : 'English (US)',
                    onTap: () {
                      context.read<LocaleCubit>().toggleLocale();
                    },
                  ),
                  _ProfileToggleItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notificações Push',
                    subtitle: 'Vendas, recebimentos, alertas',
                    value: true,
                    onChanged: (val) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileToggleItem(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometria',
                    subtitle: 'Desbloqueio com digital ou face',
                    value: false,
                    onChanged: (val) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.palette_rounded,
                    title: 'Aparência',
                    subtitle: 'Tema escuro',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),

                  const SizedBox(height: FlowSpacing.xxl),

                  // =====================================================
                  // SEÇÃO: Suporte
                  // =====================================================
                  _SectionTitle(title: 'Suporte'),
                  const SizedBox(height: FlowSpacing.sm),
                  _ProfileMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Central de Ajuda',
                    subtitle: 'Dúvidas frequentes',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Fale Conosco',
                    subtitle: 'Chat ou e-mail',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),
                  _ProfileMenuItem(
                    icon: Icons.description_outlined,
                    title: 'Termos e Políticas',
                    subtitle: 'Termos de uso e privacidade',
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
                      );
                    },
                  ),

                  const SizedBox(height: FlowSpacing.xxl),

                  // =====================================================
                  // LOGOUT
                  // =====================================================
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.read<AuthCubit>().logout();
                        context.go('/login');
                      },
                      borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: FlowSpacing.lg),
                        decoration: BoxDecoration(
                          border: Border.all(color: FlowColors.error.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(FlowSpacing.radiusMd),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded, color: FlowColors.error, size: 20),
                            const SizedBox(width: FlowSpacing.sm),
                            Text(
                              l10n.profileLogout,
                              style: FlowTypography.titleMedium.copyWith(
                                color: FlowColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: FlowSpacing.lg),

                  // Versão do App
                  Center(
                    child: Text(
                      'FlowPay v1.0.0',
                      style: FlowTypography.labelSmall,
                    ),
                  ),

                  const SizedBox(height: FlowSpacing.xxl * 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _getSegmentLabel(MerchantSegment segment) {
    switch (segment) {
      case MerchantSegment.foodAndBeverage:
        return 'Alimentação e Bebidas';
      case MerchantSegment.retail:
        return 'Varejo';
      case MerchantSegment.services:
        return 'Serviços';
      case MerchantSegment.healthAndBeauty:
        return 'Saúde e Beleza';
      case MerchantSegment.technology:
        return 'Tecnologia';
      case MerchantSegment.other:
        return 'Outros';
    }
  }

  void _showFeeTable(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FlowColors.surface,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(FlowSpacing.radiusXl)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          FlowSpacing.xl,
          FlowSpacing.xl,
          FlowSpacing.xl,
          MediaQuery.of(context).padding.bottom + FlowSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlowColors.textTertiary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: FlowSpacing.lg),
            Text(
              'Tabela de Taxas',
              style: FlowTypography.headlineSmall.copyWith(color: FlowColors.textPrimary),
            ),
            const SizedBox(height: FlowSpacing.xs),
            Text(
              'Valores por transação aprovada',
              style: FlowTypography.bodySmall.copyWith(color: FlowColors.textSecondary),
            ),
            const SizedBox(height: FlowSpacing.xl),

            // PIX
            Text(
              'Pix',
              style: FlowTypography.titleMedium.copyWith(color: FlowColors.brandPix),
            ),
            const SizedBox(height: FlowSpacing.xs),
            const _FeeRow(brand: 'Pix', fee: '0,00%'),

            const SizedBox(height: FlowSpacing.lg),

            // DÉBITO
            Text(
              'Débito',
              style: FlowTypography.titleMedium.copyWith(color: FlowColors.primaryGradientEnd),
            ),
            const SizedBox(height: FlowSpacing.xs),
            const _FeeRow(brand: 'Visa', fee: '1,50%'),
            const _FeeRow(brand: 'Mastercard', fee: '1,50%'),
            const _FeeRow(brand: 'Elo', fee: '2,00%'),
            const _FeeRow(brand: 'Amex', fee: '2,50%'),

            const SizedBox(height: FlowSpacing.lg),

            // CRÉDITO
            Text(
              'Crédito à Vista',
              style: FlowTypography.titleMedium.copyWith(color: FlowColors.primary),
            ),
            const SizedBox(height: FlowSpacing.xxs),
            Text(
              '+1,50% por parcela adicional',
              style: FlowTypography.bodySmall.copyWith(color: FlowColors.textTertiary),
            ),
            const SizedBox(height: FlowSpacing.xs),
            const _FeeRow(brand: 'Visa', fee: '3,50%'),
            const _FeeRow(brand: 'Mastercard', fee: '3,50%'),
            const _FeeRow(brand: 'Elo', fee: '4,50%'),
            const _FeeRow(brand: 'Amex', fee: '5,50%'),

            const SizedBox(height: FlowSpacing.lg),
            Divider(color: FlowColors.divider),
            const SizedBox(height: FlowSpacing.sm),
            Center(
              child: Text(
                'Taxas válidas para o plano atual',
                style: FlowTypography.labelSmall,
              ),
            ),
            const SizedBox(height: FlowSpacing.md),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SUB-WIDGETS PRIVADOS
// =============================================================================

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: FlowTypography.labelLarge.copyWith(
        color: FlowColors.textTertiary,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? FlowColors.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: FlowSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(FlowSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: FlowSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: FlowTypography.bodyMedium.copyWith(
                        color: FlowColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: FlowSpacing.xxs),
                    Text(
                      subtitle,
                      style: FlowTypography.bodySmall.copyWith(
                        color: FlowColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade700, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileToggleItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileToggleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FlowSpacing.md),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(FlowSpacing.sm),
            decoration: BoxDecoration(
              color: FlowColors.textSecondary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(FlowSpacing.radiusSm),
            ),
            child: Icon(icon, color: FlowColors.textSecondary, size: 20),
          ),
          const SizedBox(width: FlowSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FlowTypography.bodyMedium.copyWith(
                    color: FlowColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: FlowSpacing.xxs),
                Text(
                  subtitle,
                  style: FlowTypography.bodySmall.copyWith(
                    color: FlowColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: FlowColors.primary,
            inactiveTrackColor: FlowColors.surfaceHighlight,
          ),
        ],
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  final String brand;
  const _BrandLogo({required this.brand});

  @override
  Widget build(BuildContext context) {
    String assetName;
    if (brand.toLowerCase().contains('visa')) {
      assetName = 'icons/visa.png';
    } else if (brand.toLowerCase().contains('mastercard')) {
      assetName = 'icons/mastercard.png';
    } else if (brand.toLowerCase().contains('elo')) {
      assetName = 'icons/elo.png';
    } else if (brand.toLowerCase().contains('amex')) {
      assetName = 'icons/amex.png';
    } else {
      return Icon(Icons.pix, color: FlowColors.brandPix, size: 20);
    }

    return Image.asset(
      assetName,
      package: 'flutter_credit_card_brazilian',
      width: 32,
      height: 20,
      fit: BoxFit.contain,
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String brand;
  final String fee;

  const _FeeRow({
    required this.brand,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FlowSpacing.sm),
      child: Row(
        children: [
          _BrandLogo(brand: brand),
          const SizedBox(width: FlowSpacing.md),
          Expanded(
            child: Text(
              brand,
              style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textPrimary),
            ),
          ),
          Text(
            fee,
            style: FlowTypography.moneySmall.copyWith(
              color: FlowColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
