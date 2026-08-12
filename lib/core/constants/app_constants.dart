import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Telecom AI';
  static const String appVersion = '1.0.0';
  
  // Helper to safely access dotenv or return fallback
  static String _getEnv(String key, String fallback) {
    try {
      return dotenv.get(key, fallback: fallback);
    } catch (_) {
      return fallback;
    }
  }

  // Supabase
  static String get supabaseUrl => _getEnv('SUPABASE_URL', 'https://sosxbgmmdgzbodqkghss.supabase.co');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY', 'sb_publishable__B6Nvuw195njhA6T5grGsg_Y6Ic2VxX');
  
  // ML API
  static String get mlApiBaseUrl => _getEnv('API_BASE_URL', 'https://telecommaintt.onrender.com');
}
