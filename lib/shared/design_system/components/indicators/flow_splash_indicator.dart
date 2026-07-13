import 'package:flutter/material.dart';

class FlowSplashPainter extends CustomPainter {
  FlowSplashPainter({
    required this.radius,
    required this.gradientColors,
    required this.strokeWidth,
  });
  
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: gradientColors,
      ).createShader(rect);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class FlowSplashIndicator extends StatefulWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;

  const FlowSplashIndicator({
    super.key,
    required this.radius,
    required this.gradientColors,
    this.strokeWidth = 4.0,
  });

  @override
  State<FlowSplashIndicator> createState() => _FlowSplashIndicatorState();
}

class _FlowSplashIndicatorState extends State<FlowSplashIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 1),
    );
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return RotationTransition(
          turns: _animation,
          child: CustomPaint(
            size: Size.fromRadius(widget.radius),
            painter: FlowSplashPainter(
              radius: widget.radius,
              gradientColors: widget.gradientColors,
              strokeWidth: widget.strokeWidth,
            ),
          ),
        );
      },
    );
  }
}
