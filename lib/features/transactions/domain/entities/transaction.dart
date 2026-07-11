import 'package:equatable/equatable.dart';
import 'package:money2/money2.dart';

enum TransactionStatus { approved, declined, refunded, pending, chargeback }

enum PaymentMethod { credit, debit, pix, boleto }

enum CardBrand { visa, mastercard, elo, amex }

enum TransactionType { sale, transferIn, transferOut }

extension PaymentMethodExtension on PaymentMethod {
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

extension CardBrandExtension on CardBrand {
  String get displayName {
    switch (this) {
      case CardBrand.visa:
        return 'Visa';
      case CardBrand.mastercard:
        return 'Mastercard';
      case CardBrand.elo:
        return 'Elo';
      case CardBrand.amex:
        return 'Amex';
    }
  }
}

extension TransactionStatusExtension on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.approved:
        return 'Aprovada';
      case TransactionStatus.declined:
        return 'Recusada';
      case TransactionStatus.refunded:
        return 'Reembolsada';
      case TransactionStatus.pending:
        return 'Pendente';
      case TransactionStatus.chargeback:
        return 'Chargeback';
    }
  }
}

class TransactionEntity extends Equatable {
  final String id;
  final String merchantId;
  final TransactionType type;
  final Money amount;
  final Money netAmount;
  final Money feeAmount;
  final TransactionStatus status;
  final PaymentMethod paymentMethod;
  final CardBrand? cardBrand;
  final int installments;
  final String? customerName;
  final String? cardLastFour;
  final String? authorizationCode;
  final String? nsu;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionEntity({
    required this.id,
    required this.merchantId,
    this.type = TransactionType.sale,
    required this.amount,
    required this.netAmount,
    required this.feeAmount,
    required this.status,
    required this.paymentMethod,
    this.cardBrand,
    this.installments = 1,
    this.customerName,
    this.cardLastFour,
    this.authorizationCode,
    this.nsu,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        merchantId,
        type,
        amount,
        netAmount,
        feeAmount,
        status,
        paymentMethod,
        cardBrand,
        installments,
        customerName,
        cardLastFour,
        authorizationCode,
        nsu,
        description,
        createdAt,
        updatedAt,
      ];
}
