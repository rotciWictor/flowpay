import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'package:flowpay/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowpay/features/auth/data/models/merchant_model.dart';
import 'package:flowpay/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import 'package:flowpay/features/auth/domain/usecases/check_auth.dart';
import 'package:flowpay/features/auth/domain/usecases/login_with_email.dart';
import 'package:flowpay/features/auth/domain/usecases/login_with_google.dart';
import 'package:flowpay/features/auth/domain/usecases/logout.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flowpay/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;
  late CheckAuth checkAuth;
  late LoginWithEmail loginWithEmail;
  late LoginWithGoogle loginWithGoogle;
  late Logout logout;
  late AuthCubit cubit;

  setUp(() {
    // 1. Arrange: Avoiding Over-Mocking
    mockDatasource = MockAuthRemoteDatasource();
    
    // We instantiate real models all the way up to the BLoC
    repository = AuthRepositoryImpl(mockDatasource);
    checkAuth = CheckAuth(repository);
    loginWithEmail = LoginWithEmail(repository);
    loginWithGoogle = LoginWithGoogle(repository);
    logout = Logout(repository);

    cubit = AuthCubit(
      checkAuth: checkAuth,
      loginWithEmail: loginWithEmail,
      loginWithGoogle: loginWithGoogle,
      logout: logout,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AuthCubit', () {
    const tMerchantModel = MerchantModel(
      id: '123',
      email: 'test@flowpay.com',
      handle: 'testhandle',
      businessName: 'Test Business',
      document: '12345678900',
      segment: MerchantSegment.services,
    );

    test('initial state should be AuthInitial', () {
      expect(cubit.state, isA<AuthInitial>());
    });

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthAuthenticated] when loginWithEmail is successful',
      build: () {
        when(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123'))
            .thenAnswer((_) async => tMerchantModel);
        return cubit;
      },
      act: (cubit) => cubit.login('test@flowpay.com', 'password123'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>().having(
          (state) => state.merchant.id,
          'merchant id',
          '123',
        ),
      ],
      verify: (_) {
        verify(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123')).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthError] when loginWithEmail fails with AuthException (Unhappy Path)',
      build: () {
        when(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123'))
            .thenThrow(const AuthException('Invalid credentials'));
        return cubit;
      },
      act: (cubit) => cubit.login('test@flowpay.com', 'password123'),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.message,
          'error message',
          'Invalid credentials',
        ),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthUnauthenticated] when checkSession throws AuthException',
      build: () {
        when(() => mockDatasource.checkAuthSession())
            .thenThrow(const AuthException('Nenhuma sessão ativa.'));
        return cubit;
      },
      act: (cubit) => cubit.checkSession(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'should emit [AuthLoading, AuthUnauthenticated] when logout is called',
      build: () {
        when(() => mockDatasource.logout()).thenAnswer((_) async => {});
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthUnauthenticated>(),
      ],
    );
  });
}
