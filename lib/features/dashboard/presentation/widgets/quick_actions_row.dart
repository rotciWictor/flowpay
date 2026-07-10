import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionIcon(
          icon: Icons.qr_code,
          label: AppLocalizations.of(context)!.dashboardQuickActionPix,
          onTap: () {
            // TODO: Navigate to charges
          },
        ),
        _ActionIcon(
          icon: Icons.pix,
          label: 'Pix', // Usually brand names are not translated
          onTap: () {
            // TODO: Open Pix menu
          },
        ),
        _ActionIcon(
          icon: Icons.receipt_long,
          label: AppLocalizations.of(context)!.bottomNavTransactions, // Using same string "Extrato/Transactions"
          onTap: () {
            // TODO: Navigate to transactions
          },
        ),
        _ActionIcon(
          icon: Icons.fast_forward,
          label: AppLocalizations.of(context)!.dashboardQuickActionTransfer, // Anticipate/Transfer
          onTap: () {
            // TODO: Open anticipation simulator
          },
        ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              // Efeito Neon Bi-Color (Limiar da Percepção)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(-2, -2),
              ),
              BoxShadow(
                color: AppColors.primaryGradientEnd.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
              // Relevo Físico do botão contra a tela
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.8),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Textura Metálica (Metal Fosco de Carro de Luxo)
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15), // Luz batendo em cima
                    AppColors.surfaceVariant, // Centro fosco
                    Colors.black.withValues(alpha: 0.5), // Sombra de oclusão embaixo
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                color: AppColors.surfaceVariant,
                // Bevel Metálico (Luz batendo em cima, sombra embaixo)
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1), 
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(28),
                splashColor: AppColors.primary.withValues(alpha: 0.1),
                highlightColor: AppColors.primary.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  // Ícone subindo com profundidade
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
