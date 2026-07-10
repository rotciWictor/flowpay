import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart';

enum TransactionStatus {
  approved,
  pending,
  failed,
  refunded;

  String get displayName {
    switch (this) {
      case TransactionStatus.approved:
        return 'Aprovada';
      case TransactionStatus.pending:
        return 'Pendente';
      case TransactionStatus.failed:
        return 'Falha';
      case TransactionStatus.refunded:
        return 'Reembolsada';
    }
  }
}

enum PaymentMethod {
  credit,
  debit,
  pix,
  boleto;

  String get displayName {
    switch (this) {
      case PaymentMethod.credit:
        return 'Crédito';
      case PaymentMethod.debit:
        return 'Débito';
      case PaymentMethod.pix:
        return 'Pix';
      case PaymentMethod.boleto:
        return 'Boleto';
    }
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final String merchantId;
  final Money amount;
  final Money netAmount;
  final Money feeAmount;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.merchantId,
    required this.amount,
    required this.netAmount,
    required this.feeAmount,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        merchantId,
        amount,
        netAmount,
        feeAmount,
        status,
        paymentMethod,
        createdAt,
      ];
}
