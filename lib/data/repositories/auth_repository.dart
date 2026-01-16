import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/errors.dart';

class AuthRepository {
  final _client = Supabase.instance.client;

  Future<void> signUp(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    if (res.user == null) throw AuthError('Signup failed');
  }

  Future<void> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(email: email, password: password);
    if (res.user == null) throw AuthError('Login failed');
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  String? get currentUserId => _client.auth.currentUser?.id;
}
