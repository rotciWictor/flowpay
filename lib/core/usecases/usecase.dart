import 'package:dartz/dartz.dart';
import 'package:fintech_app/core/error/failures.dart';

/// Abstract contract for all use cases in the app.
///
/// Every use case has a single responsibility: execute one business action.
/// - [Type] is the return type on success (e.g., List<Transaction>)
/// - [Params] is the input parameters (e.g., GetTransactionsParams)
///
/// Returns [Either<Failure, Type>]:
/// - Left(Failure) on error
/// - Right(Type) on success
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use this when a use case doesn't need any parameters.
///
/// Example: GetCurrentMerchant doesn't need params, so:
/// ```dart
/// class GetCurrentMerchant implements UseCase<Merchant, NoParams> { ... }
/// ```
class NoParams {
  const NoParams();
}
