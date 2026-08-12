import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Telecom AI';
  static const String appVersion = '1.0.0';
  
  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  
  // ML API
  static String get mlApiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
}
