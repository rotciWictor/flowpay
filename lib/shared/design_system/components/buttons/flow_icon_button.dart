import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/behavior/flow_haptics.dart';

/// FlowIconButton
///
/// Botão de ação rápida com efeito metálico e sombra neon bicolor.
/// Já injeta o Haptic Feedback (Light Impact) ao ser tocado.
class FlowIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FlowIconButton({
    super.key,
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
                color: FlowColors.primary.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(-2, -2),
              ),
              BoxShadow(
                color: FlowColors.primaryGradientEnd.withValues(alpha: 0.08),
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
                // Textura Metálica (Metal Fosco)
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.15), // Luz batendo em cima
                    FlowColors.surfaceVariant, // Centro fosco
                    Colors.black.withValues(alpha: 0.5), // Sombra de oclusão embaixo
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                color: FlowColors.surfaceVariant,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: InkWell(
                onTap: () async {
                  await FlowHaptics.lightImpact();
                  onTap();
                },
                borderRadius: BorderRadius.circular(FlowSpacing.radiusPill),
                splashColor: FlowColors.primary.withValues(alpha: 0.1),
                highlightColor: FlowColors.primary.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(FlowSpacing.md),
                  // Ícone subindo com profundidade
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                    shadows: const [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: FlowSpacing.sm),
        Text(
          label,
          style: FlowTypography.labelMedium.copyWith(
            color: FlowColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
