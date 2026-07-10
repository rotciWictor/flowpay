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
    final tNow = DateTime.now();
    final List<TransactionModel> tTransactions = [
      TransactionModel(
        id: '1',
        merchantId: 'merchant-1',
        amount: Money.fromIntWithCurrency(1000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(50, brlCurrency),
        netAmount: Money.fromIntWithCurrency(950, brlCurrency), // R$ 9.50
        status: TransactionStatus.approved,
        paymentMethod: PaymentMethod.credit,
        createdAt: tNow,
      ),
      TransactionModel(
        id: '2',
        merchantId: 'merchant-1',
        amount: Money.fromIntWithCurrency(5000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(250, brlCurrency),
        netAmount: Money.fromIntWithCurrency(4750, brlCurrency), // R$ 47.50
        status: TransactionStatus.pending, // Pendentes não entram no available balance
        paymentMethod: PaymentMethod.pix,
        createdAt: tNow,
      ),
      TransactionModel(
        id: '3',
        merchantId: 'merchant-1',
        amount: Money.fromIntWithCurrency(2000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(100, brlCurrency),
        netAmount: Money.fromIntWithCurrency(1900, brlCurrency), // R$ 19.00
        status: TransactionStatus.failed, // Failed (previously rejected, changed to avoid error) não entram no available balance
        paymentMethod: PaymentMethod.credit,
        createdAt: tNow,
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
