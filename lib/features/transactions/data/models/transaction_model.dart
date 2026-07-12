import 'package:flowpay/core/utils/currency_format.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:money2/money2.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.merchantId,
    super.type = TransactionType.sale,
    required super.amount,
    required super.netAmount,
    required super.feeAmount,
    required super.status,
    required super.paymentMethod,
    super.cardBrand,
    super.installments = 1,
    super.customerName,
    super.cardLastFour,
    super.authorizationCode,
    super.nsu,
    super.description,
    super.returnCode,
    required super.createdAt,
    required super.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      merchantId: json['merchant_id'],
      type: _parseType(json['transaction_type'] ?? 'sale'),
      amount: Money.fromIntWithCurrency(json['amount'] as int, brlCurrency),
      netAmount: Money.fromIntWithCurrency(json['net_amount'] as int, brlCurrency),
      feeAmount: Money.fromIntWithCurrency(json['fee_amount'] as int, brlCurrency),
      status: _parseStatus(json['status']),
      paymentMethod: _parsePaymentMethod(json['payment_method']),
      cardBrand: _parseCardBrand(json['card_brand']),
      installments: json['installments'] ?? 1,
      customerName: json['customer_name'] as String?,
      cardLastFour: json['card_last_four'] as String?,
      authorizationCode: json['authorization_code'] as String?,
      nsu: json['nsu'] as String?,
      description: json['description'] as String?,
      returnCode: json['return_code'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static TransactionType _parseType(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'transfer_in':
        return TransactionType.transferIn;
      case 'transfer_out':
        return TransactionType.transferOut;
      case 'sale':
      default:
        return TransactionType.sale;
    }
  }

  static TransactionStatus _parseStatus(String status) {
    switch (status) {
      case 'approved':
        return TransactionStatus.approved;
      case 'declined':
      case 'failed':
        return TransactionStatus.declined;
      case 'refunded':
        return TransactionStatus.refunded;
      case 'pending':
        return TransactionStatus.pending;
      case 'chargeback':
        return TransactionStatus.chargeback;
      default:
        return TransactionStatus.pending;
    }
  }

  static PaymentMethod _parsePaymentMethod(String method) {
    switch (method) {
      case 'credit':
        return PaymentMethod.credit;
      case 'debit':
        return PaymentMethod.debit;
      case 'boleto':
        return PaymentMethod.boleto;
      case 'pix':
      default:
        return PaymentMethod.pix;
    }
  }

  static CardBrand? _parseCardBrand(String? brand) {
    if (brand == null) return null;
    switch (brand) {
      case 'visa':
        return CardBrand.visa;
      case 'mastercard':
        return CardBrand.mastercard;
      case 'elo':
        return CardBrand.elo;
      case 'amex':
        return CardBrand.amex;
      default:
        return null;
    }
  }
}
