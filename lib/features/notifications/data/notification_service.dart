import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/sms_service.dart';
import '../../../core/constants/app_constants.dart';

final notificationServiceProvider = Provider((ref) => NotificationService(
  Supabase.instance.client,
  ref.read(smsServiceProvider),
));

class NotificationService {
  final SupabaseClient _client;
  final SmsService _smsService;

  NotificationService(this._client, this._smsService);

  void subscribeToAlarms() {
    _client
        .channel('public:alarm_logs')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'alarm_logs',
          callback: (payload) async {
            final alarm = payload.newRecord;
            final severity = alarm['severity'] as String?;
            
            // Only send SMS for Critical or Major alarms
            if (severity == 'Critical' || severity == 'Major') {
              final adminPhone = AppConstants.adminPhoneNumber;
              if (adminPhone.isNotEmpty) {
                final String message = 
                    '🚨 TELECOM AI ALERT\n'
                    'Alarm: ${alarm['description']}\n'
                    'Site ID: ${alarm['station_id']}\n'
                    'Severity: $severity\n'
                    'Time: ${DateTime.now().toString().substring(11, 16)}';
                    
                await _smsService.sendSms(
                  phoneNumber: adminPhone,
                  message: message,
                );
              }
            }
          },
        )
        .subscribe();
  }
}
