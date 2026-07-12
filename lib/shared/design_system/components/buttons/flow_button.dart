import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';

/// FlowButton
///
/// Botão primário do sistema. Segue a estética premium "Liquid Glass",
/// com borda gradiente e fundo escuro (Ghost button), além de 
/// sombra neon.
enum FlowButtonVariant { solid, outline }

class FlowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final IconData? icon;
  final FlowButtonVariant variant;
  final Color? textColor;

  const FlowButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.icon,
    this.variant = FlowButtonVariant.solid,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isOutline = variant == FlowButtonVariant.outline;
    final defaultTextColor = textColor ?? FlowColors.textPrimary;

    return Container(
      // Outer Container acts as the Gradient Border
      padding: EdgeInsets.all(isOutline ? 1.0 : 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: isOutline 
          ? LinearGradient(
              colors: [FlowColors.textSecondary.withValues(alpha: 0.3), FlowColors.textTertiary.withValues(alpha: 0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : const LinearGradient(
              colors: [FlowColors.primary, FlowColors.primaryGradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        boxShadow: isOutline ? null : [
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
          borderRadius: BorderRadius.circular(isOutline ? 13.0 : 12.5),
          color: isOutline ? FlowColors.surface : const Color(0xFF1A1D27).withValues(alpha: 0.95),
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: defaultTextColor),
                      const SizedBox(width: FlowSpacing.sm),
                    ],
                    Text(
                      label,
                      style: FlowTypography.labelLarge.copyWith(
                        fontSize: 16,
                        letterSpacing: 1.0,
                        color: defaultTextColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
