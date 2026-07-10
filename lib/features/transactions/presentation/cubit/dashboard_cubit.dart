import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowpay/features/transactions/domain/usecases/get_dashboard_data.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardData getDashboardData;
  final SupabaseClient supabaseClient;

  DashboardCubit({
    required this.getDashboardData,
    required this.supabaseClient,
  }) : super(DashboardInitial());

  Future<void> fetchDashboard() async {
    emit(DashboardLoading());
    
    // Obter o merchantId do usuário logado
    final user = supabaseClient.auth.currentUser;
    if (user == null) {
      emit(const DashboardError(message: 'Usuário não autenticado.'));
      return;
    }

    final result = await getDashboardData(GetDashboardDataParams(merchantId: user.id));

    result.fold(
      (failure) => emit(const DashboardError(message: 'Falha ao carregar o painel.')),
      (data) => emit(DashboardLoaded(dashboardData: data)),
    );
  }
}
