import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(Supabase.instance.client));

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return null;
  return await authRepo.getUserProfile(user.id);
});

final rolesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  return await authRepo.getRoles();
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
    required int roleId,
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
        'role_id': roleId,
      },
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<String?> uploadAvatar(Uint8List bytes, String fileName, String userId) async {
    final fileExtension = fileName.split('.').last;
    final path = '$userId/avatar.$fileExtension';

    await _client.storage.from('avatars').uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    final String publicUrl = _client.storage.from('avatars').getPublicUrl(path);
    
    await _client.from('profiles').update({'avatar_url': publicUrl}).eq('id', userId);
    
    return publicUrl;
  }

  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      // 1. Fetch the profile data first (no join)
      final profile = await _client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();
      
      // 2. Try to fetch the role name separately if role_id exists
      if (profile['role_id'] != null) {
        try {
          final roleData = await _client
              .from('roles')
              .select('name')
              .eq('id', profile['role_id'])
              .single();
          profile['roles'] = roleData;
        } catch (_) {
          profile['roles'] = {'name': 'User'};
        }
      } else {
        profile['roles'] = {'name': 'User'};
      }
      
      return profile;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getRoles() async {
    final response = await _client.from('roles').select().order('id');
    return List<Map<String, dynamic>>.from(response);
  }
}
