import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flowpay/features/transactions/domain/entities/dashboard_data.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';

class WeeklySalesChart extends StatelessWidget {
  final List<DailySale> weeklySales;

  const WeeklySalesChart({super.key, required this.weeklySales});

  @override
  Widget build(BuildContext context) {
    if (weeklySales.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: FlowColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
        ),
        child: const Center(child: Text('Sem dados na semana')),
      );
    }

    final maxSale = weeklySales.map((e) => e.totalAmount.minorUnits.toInt() / 100).reduce((a, b) => a > b ? a : b).toDouble();
    final maxY = maxSale == 0 ? 100.0 : maxSale * 1.2;

    final gradientColors = [
      FlowColors.primary,
      FlowColors.primaryGradientEnd,
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.only(top: FlowSpacing.xxl, bottom: FlowSpacing.sm, left: 0, right: 0),
      decoration: BoxDecoration(
        color: FlowColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: LineChart(
        LineChartData(
          clipData: const FlClipData.all(),
          minX: 1,
          maxX: (weeklySales.length - 2).toDouble(),
          minY: 0,
          maxY: maxY,
          lineTouchData: LineTouchData(
            enabled: true,
            touchSpotThreshold: 30, // Aumenta a área de toque invisível
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipColor: (group) => FlowColors.surface,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final date = weeklySales[index].date;
                  final dateStr = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
                  
                  return LineTooltipItem(
                    'R\$ ${spot.y.toStringAsFixed(2)}\nem $dateStr',
                    FlowTypography.labelLarge.copyWith(color: FlowColors.textPrimary),
                  );
                }).toList();
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < weeklySales.length) {
                    final date = weeklySales[index].date;
                    final text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
                    
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      fitInside: SideTitleFitInsideData.fromTitleMeta(
                        meta,
                        distanceFromEdge: 0,
                      ),
                      child: Text(text, style: FlowTypography.labelSmall.copyWith(color: FlowColors.textSecondary)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4 == 0 ? 1 : maxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.white.withValues(alpha: 0.05),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: weeklySales.asMap().entries.map((entry) {
                final index = entry.key;
                final sale = entry.value;
                return FlSpot(
                  index.toDouble(),
                  sale.totalAmount.minorUnits.toInt() / 100,
                );
              }).toList(),
              isCurved: true,
              preventCurveOverShooting: true,
              gradient: LinearGradient(colors: gradientColors),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors.map((color) => color.withValues(alpha: 0.3)).toList(),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
