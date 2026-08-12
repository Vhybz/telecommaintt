import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String appName = 'Telecom AI';
  static const String appVersion = '1.0.0';
  
  // Supabase
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? 'https://sosxbgmmdgzbodqkghss.supabase.co';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? 'sb_publishable__B6Nvuw195njhA6T5grGsg_Y6Ic2VxX';
  
  // ML API
  static String get mlApiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'https://telecommaintt.onrender.com';
}
