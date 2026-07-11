import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money2/money2.dart';

import 'package:flowpay/core/error/exceptions.dart';
import 'package:flowpay/core/error/failures.dart';
import 'package:flowpay/core/utils/currency_format.dart';
import 'package:flowpay/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:flowpay/features/transactions/data/models/transaction_model.dart';
import 'package:flowpay/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';

class MockTransactionsRemoteDatasource extends Mock implements TransactionsRemoteDatasource {}

void main() {
  late MockTransactionsRemoteDatasource mockDatasource;
  late TransactionsRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockTransactionsRemoteDatasource();
    repository = TransactionsRepositoryImpl(remoteDatasource: mockDatasource);
  });

  group('TransactionsRepositoryImpl - getAvailableBalance', () {
    final tTransactionModel = TransactionModel(
      id: '123',
      merchantId: 'merchant1',
      amount: Money.fromIntWithCurrency(15000, brlCurrency),
      netAmount: Money.fromIntWithCurrency(14500, brlCurrency),
      feeAmount: Money.fromIntWithCurrency(500, brlCurrency),
      status: TransactionStatus.approved,
      paymentMethod: PaymentMethod.credit,
      createdAt: DateTime.parse('2026-07-10T12:00:00Z'),
      updatedAt: DateTime.parse('2026-07-10T12:00:00Z'),
    );

    final tTransactions = [
      tTransactionModel,
      TransactionModel(
        id: '456',
        merchantId: 'merchant1',
        amount: Money.fromIntWithCurrency(5000, brlCurrency),
        netAmount: Money.fromIntWithCurrency(4900, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(100, brlCurrency),
        status: TransactionStatus.pending,
        paymentMethod: PaymentMethod.pix,
        createdAt: DateTime.parse('2026-07-10T13:00:00Z'),
        updatedAt: DateTime.parse('2026-07-10T13:00:00Z'),
      ),
      TransactionModel(
        id: '789',
        merchantId: 'merchant1',
        amount: Money.fromIntWithCurrency(20000, brlCurrency),
        netAmount: Money.fromIntWithCurrency(19000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(1000, brlCurrency),
        status: TransactionStatus.declined,
        paymentMethod: PaymentMethod.debit,
        createdAt: DateTime.parse('2026-07-10T14:00:00Z'),
        updatedAt: DateTime.parse('2026-07-10T14:00:00Z'),
      ),
    ];

    test('should return Money representing sum of netAmount of ONLY approved transactions', () async {
      // Arrange
      when(() => mockDatasource.getTransactions())
          .thenAnswer((_) async => tTransactions);

      // Act
      final result = await repository.getAvailableBalance();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Should not return failure'),
        (balance) {
          // It should sum ONLY the approved transaction (netAmount: 950)
          expect(balance.minorUnits.toInt(), 950);
        },
      );
      verify(() => mockDatasource.getTransactions()).called(1);
    });

    test('should return ServerFailure when datasource throws ServerException', () async {
      // Arrange
      when(() => mockDatasource.getTransactions())
          .thenThrow(ServerException(message: 'Database connection failed'));

      // Act
      final result = await repository.getAvailableBalance();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ServerFailure>());
          expect(failure.message, 'Database connection failed');
        },
        (_) => fail('Should not return success'),
      );
    });
  });
}
