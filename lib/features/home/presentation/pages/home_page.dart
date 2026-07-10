import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowpay/injection.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_cubit.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flowpay/app/theme/app_colors.dart';
import 'package:flowpay/app/theme/app_spacing.dart';
import 'package:flowpay/features/home/presentation/widgets/weekly_sales_chart.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..fetchDashboard(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  bool _obscureBalance = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().fetchDashboard(),
          child: BlocBuilder<DashboardCubit, DashboardState>(
            builder: (context, state) {
              if (state is DashboardInitial || state is DashboardLoading) {
                return _buildShimmerLoading();
              } else if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: const TextStyle(color: AppColors.error)),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => context.read<DashboardCubit>().fetchDashboard(),
                        child: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                );
              } else if (state is DashboardLoaded) {
                final data = state.dashboardData;
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(data.availableBalance.toString()),
                            const SizedBox(height: AppSpacing.lg),
                            _buildNextSettlementCard(
                              data.nextSettlementAmount.toString(),
                              data.nextSettlementDate,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _buildQuickActions(),
                            const SizedBox(height: AppSpacing.lg),
                            const Text(
                              'Vendas da Semana',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            WeeklySalesChart(weeklySales: data.weeklySales),
                            const SizedBox(height: AppSpacing.lg),
                            const Text(
                              'Últimas Transações',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final tx = data.recentTransactions[index];
                          final isIncome = tx.amount.minorUnits.toInt() > 0 && tx.status == TransactionStatus.approved;
                          final amountColor = isIncome ? AppColors.successMint : Colors.white;
                          
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isIncome ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                              child: Icon(
                                isIncome ? Icons.arrow_downward : Icons.credit_card,
                                color: isIncome ? AppColors.primary : Colors.grey,
                              ),
                            ),
                            title: Text(
                              tx.amount.toString(),
                              style: GoogleFonts.outfit(fontWeight: FontWeight.w700, letterSpacing: -0.5, color: amountColor, fontSize: 16),
                            ),
                            subtitle: Text(tx.status.displayName, style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12)),
                            trailing: Text(
                              '${tx.createdAt.day.toString().padLeft(2, '0')}/${tx.createdAt.month.toString().padLeft(2, '0')}',
                              style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12),
                            ),
                          );
                        },
                        childCount: data.recentTransactions.length,
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String balanceStr) {
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
                Text(
                  _obscureBalance ? 'R\$ •••••••' : balanceStr,
                  style: GoogleFonts.outfit(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.0,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(_obscureBalance ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade600),
                  onPressed: () {
                    setState(() {
                      _obscureBalance = !_obscureBalance;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextSettlementCard(String amountStr, DateTime? date) {
    final dateStr = date != null ? '${date.day}/${date.month}' : 'N/A';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.20),
            AppColors.primaryGradientEnd.withValues(alpha: 0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.flash_on, color: AppColors.primary, size: 16),
                  const SizedBox(width: 4),
                  Text('A receber amanhã', style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                amountStr,
                style: GoogleFonts.outfit(
                  fontSize: 24, 
                  fontWeight: FontWeight.w700, 
                  letterSpacing: -1.0,
                  color: AppColors.primary
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(dateStr),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionIcon(icon: Icons.qr_code, label: 'Cobrar'),
        _ActionIcon(icon: Icons.pix, label: 'Pix'),
        _ActionIcon(icon: Icons.receipt_long, label: 'Extrato'),
        _ActionIcon(icon: Icons.fast_forward, label: 'Antecipar'),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surfaceHighlight,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(width: 120, height: 14, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 200, height: 40, color: Colors.white),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // NextSettlementCard
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(4, (index) => Column(
                      children: [
                        Container(width: 56, height: 56, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        const SizedBox(height: 8),
                        Container(width: 40, height: 10, color: Colors.white),
                      ],
                    )),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Chart Title
                  Container(width: 150, height: 20, color: Colors.white),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Chart
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Transactions Title
                  Container(width: 160, height: 20, color: Colors.white),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ),
          
          // Transactions List
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: const CircleAvatar(backgroundColor: Colors.white),
                  title: Container(width: 80, height: 16, color: Colors.white),
                  subtitle: Container(width: 60, height: 12, color: Colors.white),
                  trailing: Container(width: 40, height: 12, color: Colors.white),
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

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
      ],
    );
  }
}
