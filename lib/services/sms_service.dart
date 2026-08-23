import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../core/constants/app_constants.dart';

final smsServiceProvider = Provider((ref) => SmsService());

final smsBalanceProvider = FutureProvider<double?>((ref) async {
  return await ref.read(smsServiceProvider).getBalance();
});

class SmsService {
  final Dio _dio = Dio();
  final _logger = Logger(
    printer: PrettyPrinter(methodCount: 0, errorMethodCount: 5, lineLength: 50, colors: true, printEmojis: true, printTime: false),
  );

  String _normalizePhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    // If it starts with 0 and is 10 digits long (local format), replace with 233
    if (cleaned.startsWith('0') && cleaned.length == 10) {
      return '233${cleaned.substring(1)}';
    }
    
    // If it's already in 233 format, return it
    if (cleaned.startsWith('233') && cleaned.length == 12) {
      return cleaned;
    }

    // Default return cleaned
    return cleaned;
  }

  Future<bool> sendSms({
    required String phoneNumber,
    required String message,
  }) async {
    final formattedPhone = _normalizePhoneNumber(phoneNumber);
    
    try {
      if (kIsWeb) {
        // MANDATORY: Use backend proxy for Web to fix CORS error
        final String proxyUrl = '${AppConstants.mlApiBaseUrl}/send-sms';
        _logger.i('Web platform detected. Routing through proxy: $proxyUrl');
        
        final response = await _dio.post(
          proxyUrl,
          data: {
            'phoneNumber': formattedPhone,
            'message': message,
          },
        );

        if (response.statusCode == 200 && (response.data['success'] == true || response.data['success'] == 'true')) {
          _logger.i('SMS sent via proxy successfully.');
          return true;
        } else {
          _logger.w('Proxy request failed: ${response.data}');
          return false;
        }
      }

      _logger.i('Mobile/Native platform detected. Sending directly via Arkesel.');
      final String apiKey = AppConstants.arkeselApiKey;
      final String senderId = AppConstants.arkeselSenderId;

      if (apiKey.isEmpty) {
        _logger.e('Arkesel API Key is not configured');
        throw Exception('Arkesel API Key is not configured');
      }

      final response = await _dio.post(
        'https://sms.arkesel.com/api/v2/sms/send',
        options: Options(
          headers: {
            'api-key': apiKey,
            'Accept': 'application/json',
          },
        ),
        data: {
          'sender': senderId,
          'message': message,
          'recipients': [formattedPhone],
        },
      );

      // Arkesel v2 returns 201 for success
      if (response.statusCode == 201 || response.statusCode == 200) {
        _logger.i('SMS sent successfully via v2. Response: ${response.data}');
        return true;
      } else {
        _logger.w('SMS sending failed. Status: ${response.statusCode}, Data: ${response.data}');
        return false;
      }
    } catch (e) {
      _logger.e('Error sending SMS: $e');
      if (e is DioException) {
        _logger.e('Dio Error Details: ${e.response?.data}');
      }
      return false;
    }
  }

  Future<double?> getBalance() async {
    try {
      final String apiKey = AppConstants.arkeselApiKey;
      if (apiKey.isEmpty) return null;

      final response = await _dio.get(
        'https://sms.arkesel.com/api/v2/clients/balance-details',
        options: Options(
          headers: {
            'api-key': apiKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          // Arkesel v2 balance structure
          return double.tryParse(data['data']?['balance']?.toString() ?? '0');
        }
      }
      return null;
    } catch (e) {
      _logger.e('Error checking balance: $e');
      return null;
    }
  }

}
