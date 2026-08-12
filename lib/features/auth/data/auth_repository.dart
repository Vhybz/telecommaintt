import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(Supabase.instance.client));

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return null;
  return await authRepo.getUserProfile(user.id);
});

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String? profession,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'profession': profession,
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<String?> uploadAvatar(String filePath, String userId) async {
    final file = File(filePath);
    final fileExtension = filePath.split('.').last;
    final path = '$userId/avatar.$fileExtension';

    await _client.storage.from('avatars').upload(
      path,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final String publicUrl = _client.storage.from('avatars').getPublicUrl(path);
    
    await _client.from('profiles').update({'avatar_url': publicUrl}).eq('id', userId);
    
    return publicUrl;
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select('*, roles(name)')
        .eq('id', userId)
        .single();
    return response;
  }
}
