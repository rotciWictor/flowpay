import 'package:equatable/equatable.dart';
import 'package:flowpay/l10n/app_localizations.dart';
import 'package:money2/money2.dart';

enum TransactionStatus { approved, declined, refunded, pending, chargeback }

enum PaymentMethod { credit, debit, pix, boleto }

enum CardBrand { visa, mastercard, elo, amex }

enum TransactionType { sale, transferIn, transferOut }

extension PaymentMethodExtension on PaymentMethod {
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case PaymentMethod.credit:
        return l10n.paymentMethodCredit;
      case PaymentMethod.debit:
        return l10n.paymentMethodDebit;
      case PaymentMethod.pix:
        return l10n.paymentMethodPix;
      case PaymentMethod.boleto:
        return l10n.paymentMethodBoleto;
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
  String getDisplayName(AppLocalizations l10n) {
    switch (this) {
      case TransactionStatus.approved:
        return l10n.statusApproved;
      case TransactionStatus.declined:
        return l10n.statusDeclined;
      case TransactionStatus.refunded:
        return l10n.statusRefunded;
      case TransactionStatus.pending:
        return l10n.statusPending;
      case TransactionStatus.chargeback:
        return l10n.statusChargeback;
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
  final String? returnCode;
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
    this.returnCode,
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
        returnCode,
        createdAt,
        updatedAt,
      ];
}
