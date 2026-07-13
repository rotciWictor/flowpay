import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/components/indicators/flow_progress_indicator.dart';

class FlowRefreshIndicator extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const FlowRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      backgroundColor: FlowColors.surfaceHighlight,
      onRefresh: onRefresh,
      indicatorBuilder: (context, controller) {
        return const Padding(
          padding: EdgeInsets.all(6.0),
          child: FlowProgressIndicator(
            radius: 12,
            strokeWidth: 2.5,
          ),
        );
      },
      child: child,
    );
  }
}
