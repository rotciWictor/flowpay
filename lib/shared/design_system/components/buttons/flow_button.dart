import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';

/// FlowButton
///
/// Botão primário do sistema. Segue a estética premium "Liquid Glass",
/// com borda gradiente e fundo escuro (Ghost button), além de 
/// sombra neon.
class FlowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  const FlowButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Outer Container acts as the Gradient Border
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [FlowColors.primary, FlowColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: FlowColors.primary.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        // Inner Container is the dark body of the Ghost Button
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.5),
          color: const Color(0xFF1A1D27).withValues(alpha: 0.95),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(
                  label,
                  style: FlowTypography.labelLarge.copyWith(
                    fontSize: 16,
                    letterSpacing: 1.0,
                    color: FlowColors.textPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
