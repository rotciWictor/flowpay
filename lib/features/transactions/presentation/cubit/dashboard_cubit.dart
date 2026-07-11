import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowpay/features/transactions/domain/usecases/get_dashboard_data.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_state.dart';
import 'package:flowpay/core/usecases/usecase.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardData getDashboardData;

  DashboardCubit({
    required this.getDashboardData,
  }) : super(DashboardInitial());

  Future<void> fetchDashboard({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(DashboardLoading());
    }

    final result = await getDashboardData(const NoParams());

    result.fold(
      (failure) => emit(const DashboardError(message: 'Falha ao carregar o painel.')),
      (data) => emit(DashboardLoaded(dashboardData: data)),
    );
  }
}
