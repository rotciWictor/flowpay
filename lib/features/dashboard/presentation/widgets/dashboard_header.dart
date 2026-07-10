import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'dart:math' as math;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Olá, FlowPay Demo',
              style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _NeonBorderText(text: obscureBalance ? 'R\$ •••••••' : balanceStr),
                IconButton(
                  icon: Icon(
                    obscureBalance ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey.shade600,
                  ),
                  onPressed: onToggleObscure,
                ),
              ],
            ),
          ],
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
              style: GoogleFonts.outfit(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.0,
                color: Colors.transparent, // Corpo transparente, desenha apenas a sombra
                shadows: [
                  Shadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(-2, -2),
                  ),
                  Shadow(
                    color: AppColors.primaryGradientEnd.withValues(alpha: 0.15),
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
                    AppColors.primary.withValues(alpha: 0.8), // Verde vivo
                    Colors.transparent,
                    AppColors.primaryGradientEnd.withValues(alpha: 0.8), // Azul vivo
                    Colors.transparent,
                    AppColors.primary.withValues(alpha: 0.8), // Verde para fechar o ciclo
                  ],
                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                style: GoogleFonts.outfit(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.0,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 0.8 // Borda super fina, quase um fio de cabelo
                    ..color = Colors.white, // Será colorida pelo ShaderMask
                ),
              ),
            ),
            // Camada 3: O Texto Branco Sólido no Topo
            Text(
              widget.text,
              style: GoogleFonts.outfit(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.0,
                color: Colors.white,
                // Sem sombras aqui, elas já estão na Camada 1
              ),
            ),
          ],
        );
      },
    );
  }
}
