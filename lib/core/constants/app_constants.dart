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
  static String get supabaseUrl => _getEnv('SUPABASE_URL', '');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY', '');
  static String get supabaseServiceRoleKey => _getEnv('SUPABASE_SERVICE_ROLE_KEY', '');
  
  // ML API
  static String get mlApiBaseUrl => _getEnv('API_BASE_URL', 'https://telecommaintt.onrender.com');

  // Arkesel SMS
  static String get arkeselApiKey => _getEnv('ARKESEL_SMS_API_KEY', '');
  static String get arkeselSenderId => _getEnv('ARKESEL_SMS_SENDER_ID', 'TelecomMaint');
  static String get arkeselSmsBaseUrl => _getEnv('ARKESEL_SMS_BASE_URL', 'https://sms.arkesel.com/sms/api');
  static String get arkeselContactsBaseUrl => _getEnv('ARKESEL_CONTACTS_BASE_URL', 'https://sms.arkesel.com/contacts/api');

  // Notifications
  static String get adminPhoneNumber => _getEnv('ADMIN_PHONE_NUMBER', '');
}

