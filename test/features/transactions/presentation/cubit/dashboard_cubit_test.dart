import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money2/money2.dart';

import 'package:flowpay/core/error/exceptions.dart';
import 'package:flowpay/core/utils/currency_format.dart';
import 'package:flowpay/features/transactions/data/datasources/transactions_remote_datasource.dart';
import 'package:flowpay/features/transactions/data/models/transaction_model.dart';
import 'package:flowpay/features/transactions/data/repositories/transactions_repository_impl.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:flowpay/features/transactions/domain/usecases/get_dashboard_data.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_cubit.dart';
import 'package:flowpay/features/transactions/presentation/cubit/dashboard_state.dart';

class MockTransactionsRemoteDatasource extends Mock implements TransactionsRemoteDatasource {}

void main() {
  late MockTransactionsRemoteDatasource mockDatasource;
  late TransactionsRepositoryImpl repository;
  late GetDashboardData getDashboardData;
  late DashboardCubit cubit;

  setUp(() {
    // 1. Arrange: Setup without over-mocking. 
    // We only mock the strict I/O boundary (remote datasource).
    mockDatasource = MockTransactionsRemoteDatasource();
    
    // We use real instances for everything else to ensure behavioral correctness.
    repository = TransactionsRepositoryImpl(remoteDatasource: mockDatasource);
    getDashboardData = GetDashboardData(repository);
    cubit = DashboardCubit(getDashboardData: getDashboardData);
  });

  tearDown(() {
    cubit.close();
  });

  group('DashboardCubit', () {
    final tNow = DateTime.now();
    final List<TransactionModel> tTransactions = [
      TransactionModel(
        id: '1',
        merchantId: 'merchant-1',
        amount: Money.fromIntWithCurrency(10000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(500, brlCurrency),
        netAmount: Money.fromIntWithCurrency(9500, brlCurrency),
        status: TransactionStatus.approved,
        paymentMethod: PaymentMethod.credit,
        createdAt: tNow,
      ),
      TransactionModel(
        id: '2',
        merchantId: 'merchant-1',
        amount: Money.fromIntWithCurrency(5000, brlCurrency),
        feeAmount: Money.fromIntWithCurrency(250, brlCurrency),
        netAmount: Money.fromIntWithCurrency(4750, brlCurrency),
        status: TransactionStatus.pending,
        paymentMethod: PaymentMethod.pix,
        createdAt: tNow,
      )
    ];

    test('initial state should be DashboardInitial', () {
      expect(cubit.state, isA<DashboardInitial>());
    });

    blocTest<DashboardCubit, DashboardState>(
      'should emit [DashboardLoading, DashboardLoaded] with correct math aggregations when data is fetched successfully',
      build: () {
        // Arrange
        when(() => mockDatasource.getDashboardTransactions())
            .thenAnswer((_) async => tTransactions);
        return cubit;
      },
      act: (cubit) => cubit.fetchDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardLoaded>().having(
          (state) => state.dashboardData.availableBalance.minorUnits.toInt(),
          'availableBalance (only approved txs)',
          9500,
        ).having(
          (state) => state.dashboardData.nextSettlementAmount.minorUnits.toInt(),
          'nextSettlementAmount (only pending txs)',
          4750,
        ),
      ],
      verify: (_) {
        verify(() => mockDatasource.getDashboardTransactions()).called(1);
      },
    );

    blocTest<DashboardCubit, DashboardState>(
      'should emit [DashboardLoading, DashboardError] when a PostgrestException occurs (Unhappy Path)',
      build: () {
        // Arrange
        when(() => mockDatasource.getDashboardTransactions())
            .thenThrow(ServerException(message: 'Falha no banco de dados: connection timeout'));
        return cubit;
      },
      act: (cubit) => cubit.fetchDashboard(),
      expect: () => [
        isA<DashboardLoading>(),
        isA<DashboardError>().having(
          (state) => state.message,
          'error message',
          'Falha ao carregar o painel.',
        ),
      ],
    );
  });
}
