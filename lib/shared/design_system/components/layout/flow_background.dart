import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';

class FlowBackground extends StatelessWidget {
  final Widget child;
  
  const FlowBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-0.8, -0.6),
          radius: 1.5,
          colors: [
            Color(0xFF1E2433), // Slightly lighter at top left
            FlowColors.background,
          ],
        ),
      ),
      child: child,
    );
  }
}
