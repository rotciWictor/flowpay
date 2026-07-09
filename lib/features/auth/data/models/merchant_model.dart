import 'package:flowpay/features/auth/domain/entities/merchant.dart';

class MerchantModel extends Merchant {
  const MerchantModel({
    required super.id,
    required super.email,
    required super.handle,
    required super.businessName,
    required super.document,
    required super.segment,
  });

  factory MerchantModel.fromJson(Map<String, dynamic> json) {
    return MerchantModel(
      id: json['id'] as String,
      email: json['email'] as String,
      handle: json['handle'] as String? ?? '',
      businessName: json['business_name'] as String? ?? '',
      document: json['document'] as String? ?? '',
      segment: _parseSegment(json['segment'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'handle': handle,
      'business_name': businessName,
      'document': document,
      'segment': segment.name,
    };
  }

  Merchant toEntity() {
    return Merchant(
      id: id,
      email: email,
      handle: handle,
      businessName: businessName,
      document: document,
      segment: segment,
    );
  }

  static MerchantSegment _parseSegment(String? value) {
    if (value == null) return MerchantSegment.other;
    return MerchantSegment.values.firstWhere(
      (e) => e.name == value,
      orElse: () => MerchantSegment.other,
    );
  }
}
