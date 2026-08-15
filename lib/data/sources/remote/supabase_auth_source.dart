import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_client.dart';

class SupabaseAuthSource {
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  Stream<AuthState> onAuthStateChange() {
    return supabase.auth.onAuthStateChange;
  }
}
