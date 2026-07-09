import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flowpay/features/auth/domain/entities/merchant.dart';
import '../models/merchant_model.dart';

abstract class AuthRemoteDatasource {
  Future<MerchantModel> loginWithEmail({required String email, required String password});
  Future<MerchantModel> loginWithGoogle();
  Future<MerchantModel> checkAuthSession();
  Future<void> logout();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient client;

  AuthRemoteDatasourceImpl(this.client);

  @override
  Future<MerchantModel> loginWithEmail({required String email, required String password}) async {
    final response = await client.auth.signInWithPassword(email: email, password: password);
    if (response.user == null) {
      throw const AuthException('Falha no login: Usuário não encontrado.');
    }
    return _fetchMerchantData(response.user!.id, response.user!.email!);
  }

  @override
  Future<MerchantModel> loginWithGoogle() async {
    final success = await client.auth.signInWithOAuth(OAuthProvider.google);
    if (!success) {
      throw const AuthException('Falha ao autenticar com o Google.');
    }
    
    // In a real OAuth flow, this returns immediately and handles redirects.
    // Assuming we have the session:
    final session = client.auth.currentSession;
    if (session == null) {
      throw const AuthException('Sessão não encontrada após login.');
    }
    return _fetchMerchantData(session.user.id, session.user.email!);
  }

  @override
  Future<MerchantModel> checkAuthSession() async {
    final session = client.auth.currentSession;
    if (session == null) {
      throw const AuthException('Nenhuma sessão ativa.');
    }
    return _fetchMerchantData(session.user.id, session.user.email!);
  }

  @override
  Future<void> logout() async {
    await client.auth.signOut();
  }

  /// Helper to fetch merchant profile from the 'merchants' table
  Future<MerchantModel> _fetchMerchantData(String userId, String email) async {
    try {
      final data = await client
          .from('merchants')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        // This is a new user (social login first time) or missing profile.
        // In a complete flow, we would navigate to a "Complete Profile" screen.
        // For now, we return a partially filled model.
        return MerchantModel(
          id: userId,
          email: email,
          handle: '',
          businessName: '',
          document: '',
          segment: MerchantSegment.other,
        );
      }
      return MerchantModel.fromJson(data);
    } catch (e) {
      throw AuthException('Erro ao buscar perfil do lojista: $e');
    }
  }
}
