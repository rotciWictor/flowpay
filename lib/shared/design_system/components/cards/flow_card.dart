import 'package:flutter/material.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/behavior/flow_haptics.dart';

/// FlowCard
///
/// Componente de base para Cards com estilo premium (Liquid Glass/Gradient).
/// Usado para destacar informações financeiras críticas como saldos ou recebíveis.
class FlowCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const FlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(FlowSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(FlowSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: FlowColors.surfaceVariant,
            gradient: LinearGradient(
              colors: [
                FlowColors.primary.withValues(alpha: 0.20),
                FlowColors.primaryGradientEnd.withValues(alpha: 0.10),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(FlowSpacing.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap != null
                ? () async {
                    await FlowHaptics.lightImpact();
                    onTap!();
                  }
                : null,
            borderRadius: BorderRadius.circular(FlowSpacing.radiusLg),
            splashColor: FlowColors.primary.withValues(alpha: 0.2),
            highlightColor: FlowColors.primary.withValues(alpha: 0.05),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
