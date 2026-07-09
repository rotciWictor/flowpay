import 'package:equatable/equatable.dart';

/// Predefined list of business segments allowed in the app.
enum MerchantSegment {
  foodAndBeverage, // Alimentação e Bebidas
  retail,          // Varejo
  services,        // Serviços
  healthAndBeauty, // Saúde e Beleza
  technology,      // Tecnologia
  other,           // Outros
}

/// The Merchant entity representing the logged-in user and their business data.
class Merchant extends Equatable {
  final String id;
  
  // These fields must be unique in the database
  final String email;
  final String handle;        
  final String businessName;  
  final String document;      
  
  // The business segment, restricted to a predefined list
  final MerchantSegment segment;       

  const Merchant({
    required this.id,
    required this.email,
    required this.handle,
    required this.businessName,
    required this.document,
    required this.segment,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        handle,
        businessName,
        document,
        segment,
      ];
}
