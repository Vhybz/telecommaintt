import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationServiceProvider = Provider((ref) => NotificationService(Supabase.instance.client));

class NotificationService {
  final SupabaseClient _client;
  NotificationService(this._client);

  void subscribeToAlarms(Function(Map<String, dynamic>) onAlarm) {
    _client
        .channel('public:alarm_logs')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'alarm_logs',
          callback: (payload) {
            onAlarm(payload.newRecord);
          },
        )
        .subscribe();
  }
}
