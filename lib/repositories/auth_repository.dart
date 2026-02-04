import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Retorna o fluxo de autenticação atual
  Stream<AuthState> get authStateStream => _supabase.auth.onAuthStateChange;

  /// Retorna a sessão atual, se houver
  Session? get currentSession => _supabase.auth.currentSession;

  /// Envia o Magic Link para o e-mail do usuário
  /// O [redirectTo] deve ser o mesmo configurado no AndroidManifest e no Painel do Supabase
  Future<void> signInWithMagicLink(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.hunterrotine://login-callback',
        shouldCreateUser: true,
      );
    } on AuthException catch (e) {
      throw e.message; // Ou uma tradução customizada
    } catch (e) {
      throw 'Ocorreu um erro inesperado ao solicitar o login.';
    }
  }

  /// Realiza o Logout do Hunter
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw 'Erro ao tentar sair da sessão.';
    }
  }

  /// Busca os dados do perfil público para verificar se o personagem já foi criado
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return data;
    } catch (e) {
      // Se houver erro de RLS ou conexão, tratamos aqui
      return null;
    }
  }
}
