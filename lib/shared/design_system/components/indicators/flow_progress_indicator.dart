import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';

class FlowProgressIndicator extends StatefulWidget {
  final double radius;
  final double strokeWidth;

  const FlowProgressIndicator({
    super.key,
    this.radius = 20,
    this.strokeWidth = 4.0,
  });

  @override
  State<FlowProgressIndicator> createState() => _FlowProgressIndicatorState();
}

class _FlowProgressIndicatorState extends State<FlowProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1500)
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
        return CustomPaint(
          size: Size.fromRadius(widget.radius),
          painter: _FlowProgressPainter(
            animationValue: _controller.value,
            strokeWidth: widget.strokeWidth,
          ),
        );
      },
    );
  }
}

class _FlowProgressPainter extends CustomPainter {
  final double animationValue;
  final double strokeWidth;

  _FlowProgressPainter({required this.animationValue, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [FlowColors.primaryGradientEnd, FlowColors.primary, FlowColors.primaryGradientEnd],
        stops: [0.0, 0.5, 1.0],
      ).createShader(rect);

    // Animating the rotation and the arc length
    final startAngle = animationValue * 2 * math.pi;
    
    // O arco terá um tamanho fixo (ex: 75% de um círculo) para girar sem o efeito de "vai e vem" (recoil)
    const sweepAngle = math.pi * 1.5;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _FlowProgressPainter oldDelegate) => true;
}
