import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flowpay/features/auth/data/models/merchant_model.dart';
import 'package:flowpay/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';

class MockAuthRemoteDatasource extends Mock implements AuthRemoteDatasource {}

void main() {
  late MockAuthRemoteDatasource mockDatasource;
  late AuthRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockAuthRemoteDatasource();
    repository = AuthRepositoryImpl(mockDatasource);
  });

  group('AuthRepositoryImpl', () {
    const tMerchantModel = MerchantModel(
      id: '123',
      email: 'test@flowpay.com',
      handle: 'testhandle',
      businessName: 'Test Business',
      document: '12345678900',
      segment: MerchantSegment.services,
    );

    test('loginWithEmail should return Merchant when datasource is successful', () async {
      // Arrange
      when(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123'))
          .thenAnswer((_) async => tMerchantModel);

      // Act
      final result = await repository.loginWithEmail(email: 'test@flowpay.com', password: 'password123');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return Right(Merchant)'),
        (merchant) {
          expect(merchant, isA<Merchant>());
          expect(merchant.id, '123');
        },
      );
      verify(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123')).called(1);
    });

    test('loginWithEmail should return AuthFailure when datasource throws AuthException', () async {
      // Arrange
      when(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123'))
          .thenThrow(const AuthException('Invalid credentials'));

      // Act
      final result = await repository.loginWithEmail(email: 'test@flowpay.com', password: 'password123');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.message, 'Invalid credentials');
        },
        (_) => fail('Should return Left(AuthFailure)'),
      );
    });

    test('loginWithEmail should return ServerFailure when datasource throws a generic Exception', () async {
      // Arrange
      when(() => mockDatasource.loginWithEmail(email: 'test@flowpay.com', password: 'password123'))
          .thenThrow(Exception('Generic error'));

      // Act
      final result = await repository.loginWithEmail(email: 'test@flowpay.com', password: 'password123');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
        },
        (_) => fail('Should return Left(ServerFailure)'),
      );
    });
  });
}
