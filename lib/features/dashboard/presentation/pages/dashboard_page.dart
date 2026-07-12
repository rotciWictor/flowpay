import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flowpay/injection.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_cubit.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flowpay/shared/design_system/tokens/flow_colors.dart';
import 'package:flowpay/shared/design_system/tokens/flow_spacing.dart';
import 'package:flowpay/shared/design_system/tokens/flow_typography.dart';

// Components
import 'package:flowpay/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:flowpay/features/dashboard/presentation/widgets/next_settlement_card.dart';
import 'package:flowpay/features/dashboard/presentation/widgets/quick_actions_row.dart';
import 'package:flowpay/features/dashboard/presentation/widgets/weekly_sales_chart.dart';
import 'package:flowpay/features/dashboard/presentation/widgets/latest_transactions_list.dart';
import 'package:flowpay/features/transactions/presentation/widgets/transaction_details_modal.dart';
import 'package:flowpay/l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..fetchDashboard(),
      child: const _DashboardPageView(),
    );
  }
}

class _DashboardPageView extends StatefulWidget {
  const _DashboardPageView();

  @override
  State<_DashboardPageView> createState() => _DashboardPageViewState();
}

class _DashboardPageViewState extends State<_DashboardPageView> {
  bool _obscureBalance = false;

  @override
  Widget build(BuildContext context) {
    // Note: Scaffold is provided by the global AppBottomNav ShellRoute.
    return SafeArea(
      child: RefreshIndicator(
        color: FlowColors.primaryGradientEnd,
        backgroundColor: FlowColors.surfaceHighlight, // Fundo escuro levemente destacado, spinner ciano
        onRefresh: () => context.read<DashboardCubit>().fetchDashboard(isRefresh: true),
        child: BlocBuilder<DashboardCubit, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial || state is DashboardLoading) {
              return _buildShimmerLoading();
            } else if (state is DashboardError) {
              return _buildErrorState(context, state.message);
            } else if (state is DashboardLoaded) {
              final data = state.dashboardData;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(FlowSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardHeader(
                            balanceStr: data.availableBalance.toString(),
                            obscureBalance: _obscureBalance,
                            onToggleObscure: () {
                              setState(() {
                                _obscureBalance = !_obscureBalance;
                              });
                            },
                          ),
                          const SizedBox(height: FlowSpacing.lg),
                          NextSettlementCard(
                            amountStr: data.nextSettlementAmount.toString(),
                            date: data.nextSettlementDate,
                            onTap: () {
                              // TODO: Navigate to Receivables or Anticipation Simulator
                            },
                          ),
                          const SizedBox(height: FlowSpacing.lg),
                          const QuickActionsRow(),
                          const SizedBox(height: FlowSpacing.lg),
                          Text(
                            AppLocalizations.of(context)!.dashboardWeeklySales,
                            style: FlowTypography.titleLarge,
                          ),
                          const SizedBox(height: FlowSpacing.md),
                          WeeklySalesChart(weeklySales: data.weeklySales),
                          const SizedBox(height: FlowSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                  LatestTransactionsList(
                    transactions: data.recentTransactions,
                    onSeeAll: () {
                      context.go('/transactions');
                    },
                    onTransactionTap: (tx) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => TransactionDetailsModal(transaction: tx),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: FlowSpacing.md)),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(FlowSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: FlowColors.error),
            const SizedBox(height: FlowSpacing.lg),
            Text(
              AppLocalizations.of(context)!.dashboardErrorTitle,
              style: FlowTypography.titleLarge.copyWith(color: FlowColors.textPrimary),
            ),
            const SizedBox(height: FlowSpacing.sm),
            Text(
              message, 
              textAlign: TextAlign.center,
              style: FlowTypography.bodyMedium.copyWith(color: FlowColors.textSecondary),
            ),
            const SizedBox(height: FlowSpacing.xl),
            ElevatedButton.icon(
              onPressed: () => context.read<DashboardCubit>().fetchDashboard(),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(AppLocalizations.of(context)!.dashboardTryAgain),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlowColors.primary,
                foregroundColor: FlowColors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: FlowSpacing.xxl, vertical: FlowSpacing.md),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(FlowSpacing.radiusMd)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: FlowColors.surfaceVariant,
      highlightColor: FlowColors.surfaceHighlight,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(FlowSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(width: 120, height: 14, color: FlowColors.surface),
                  const SizedBox(height: FlowSpacing.sm),
                  Container(width: 200, height: 40, color: FlowColors.surface),
                  const SizedBox(height: FlowSpacing.lg),
                  
                  // NextSettlementCard
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(color: FlowColors.surface, borderRadius: BorderRadius.circular(FlowSpacing.radiusLg)),
                  ),
                  const SizedBox(height: FlowSpacing.lg),
                  
                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(4, (index) => Column(
                      children: [
                        Container(width: 56, height: 56, decoration: const BoxDecoration(color: FlowColors.surface, shape: BoxShape.circle)),
                        const SizedBox(height: FlowSpacing.sm),
                        Container(width: 40, height: 10, color: FlowColors.surface),
                      ],
                    )),
                  ),
                  const SizedBox(height: FlowSpacing.lg),
                  
                  // Chart Title
                  Container(width: 150, height: 20, color: FlowColors.surface),
                  const SizedBox(height: FlowSpacing.md),
                  
                  // Chart
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: FlowColors.surface, borderRadius: BorderRadius.circular(FlowSpacing.radiusLg)),
                  ),
                  const SizedBox(height: FlowSpacing.lg),
                  
                  // Transactions Title
                  Container(width: 160, height: 20, color: FlowColors.surface),
                  const SizedBox(height: FlowSpacing.md),
                ],
              ),
            ),
          ),
          
          // Transactions List Shimmer
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: const CircleAvatar(backgroundColor: FlowColors.surface),
                  title: Container(width: 80, height: 16, color: FlowColors.surface),
                  subtitle: Container(width: 60, height: 12, color: FlowColors.surface),
                  trailing: Container(width: 40, height: 12, color: FlowColors.surface),
                );
              },
              childCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
