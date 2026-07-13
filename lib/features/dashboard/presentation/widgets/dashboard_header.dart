import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'dart:math' as math;
import 'package:flowpay/l10n/app_localizations.dart';

class DashboardHeader extends StatelessWidget {
  final String balanceStr;
  final bool obscureBalance;
  final VoidCallback onToggleObscure;

  const DashboardHeader({
    super.key,
    required this.balanceStr,
    required this.obscureBalance,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.dashboardGreeting('FlowPay Demo'),
              style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textSecondary),
            ),
            const SizedBox(height: FlowSpacing.xs),
            Row(
              children: [
                _NeonBorderText(text: obscureBalance ? 'R\$ •••••••' : balanceStr),
                IconButton(
                  icon: Icon(
                    obscureBalance ? Icons.visibility_off : Icons.visibility,
                    color: FlowColors.textSecondary,
                  ),
                  onPressed: onToggleObscure,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: FlowColors.textSecondary),
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Em breve!'), behavior: SnackBarBehavior.floating),
            );
          },
        ),
      ],
    );
  }
}

class _NeonBorderText extends StatefulWidget {
  final String text;
  
  const _NeonBorderText({required this.text});

  @override
  State<_NeonBorderText> createState() => _NeonBorderTextState();
}

class _NeonBorderTextState extends State<_NeonBorderText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // A animação roda em um loop infinito mais lento e elegante
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Camada 1: O Brilho Fixo Neon (Fundo)
            Text(
              widget.text,
              style: FlowTypography.displayLarge.copyWith(
                fontSize: 44, // Ajuste fino para encaixar no header
                letterSpacing: -1.0,
                color: Colors.transparent, // Corpo transparente, desenha apenas a sombra
                shadows: [
                  Shadow(
                    color: FlowColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(-2, -2),
                  ),
                  Shadow(
                    color: FlowColors.primaryGradientEnd.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(2, 2),
                  ),
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.8),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            // Camada 2: Borda Neon em Movimento (Stroke)
            ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return SweepGradient(
                  center: Alignment.center,
                  transform: GradientRotation(_controller.value * 2 * math.pi), // Gira o neon ao redor do texto
                  colors: [
                    FlowColors.primary.withValues(alpha: 0.8), // Verde vivo
                    Colors.transparent,
                    FlowColors.primaryGradientEnd.withValues(alpha: 0.8), // Azul vivo
                    Colors.transparent,
                    FlowColors.primary.withValues(alpha: 0.8), // Verde para fechar o ciclo
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: FlowTypography.displayLarge.copyWith(
                  fontSize: 44,
                  letterSpacing: -1.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8 // Borda super fina, quase um fio de cabelo
                    ..color = FlowColors.textPrimary, // Será colorida pelo ShaderMask
                ),
              ),
            ),
            // Camada 3: O Texto Branco Sólido no Topo
            Text(
              widget.text,
              style: FlowTypography.displayLarge.copyWith(
                fontSize: 44,
                letterSpacing: -1.0,
                color: FlowColors.textPrimary,
                // Sem sombras aqui, elas já estão na Camada 1
              ),
            ),
          ],
        );
      },
    );
  }
}
