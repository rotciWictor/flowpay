import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/check_auth.dart';
import 'features/auth/domain/usecases/login_with_email.dart';
import 'features/auth/domain/usecases/login_with_google.dart';
import 'features/auth/domain/usecases/logout.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'core/bloc/locale_cubit.dart';
import 'features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'features/transactions/data/repositories/transactions_repository_impl.dart';
import 'features/transactions/domain/repositories/transactions_repository.dart';
import 'features/transactions/domain/usecases/get_dashboard_data.dart';
import 'features/transactions/presentation/cubit/dashboard_cubit.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // External
  sl.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // Auth Feature - Datasources
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  // Auth Feature - Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Auth Feature - UseCases
  sl.registerLazySingleton(() => LoginWithEmail(sl()));
  sl.registerLazySingleton(() => LoginWithGoogle(sl()));
  sl.registerLazySingleton(() => CheckAuth(sl()));
  sl.registerLazySingleton(() => Logout(sl()));

  // Auth Feature - Cubit
  sl.registerFactory(
    () => AuthCubit(
      checkAuth: sl(),
      loginWithEmail: sl(),
      loginWithGoogle: sl(),
      logout: sl(),
    ),
  );

  // Core - Locale Cubit
  sl.registerFactory(() => LocaleCubit());

  // Transactions Feature - Datasources
  sl.registerLazySingleton<TransactionsRemoteDatasource>(
    () => TransactionsRemoteDatasourceImpl(supabaseClient: sl()),
  );

  // Transactions Feature - Repositories
  sl.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(remoteDatasource: sl()),
  );

  // Transactions Feature - UseCases
  sl.registerLazySingleton(() => GetDashboardData(sl()));

  // Transactions Feature - Cubit
  sl.registerFactory(
    () => DashboardCubit(
      getDashboardData: sl(),
      supabaseClient: sl(),
    ),
  );
}
