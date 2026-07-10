import 'package:flowpay/core/utils/currency_format.dart';
import 'package:flowpay/features/transactions/domain/entities/transaction.dart';
import 'package:money2/money2.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,
    required super.merchantId,
    required super.amount,
    required super.netAmount,
    required super.feeAmount,
    required super.status,
    required super.paymentMethod,
    required super.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      merchantId: json['merchant_id'],
      amount: Money.fromIntWithCurrency(json['amount'] as int, brlCurrency),
      netAmount: Money.fromIntWithCurrency(json['net_amount'] as int, brlCurrency),
      feeAmount: Money.fromIntWithCurrency(json['fee_amount'] as int, brlCurrency),
      status: _parseStatus(json['status']),
      paymentMethod: _parsePaymentMethod(json['payment_method']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  static TransactionStatus _parseStatus(String status) {
    switch (status) {
      case 'approved':
        return TransactionStatus.approved;
      case 'declined':
      case 'failed':
        return TransactionStatus.failed;
      case 'refunded':
      case 'chargeback':
        return TransactionStatus.refunded;
      case 'pending':
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
}
