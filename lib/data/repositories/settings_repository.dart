import 'package:shared_preferences/shared_preferences.dart';
import '../supabase_client.dart';

class SettingsRepository {
  final _db = SupabaseService.client;

  /// Save settings locally using SharedPreferences
  Future<void> saveLocal({
    required String theme,
    required String accent,
    required double fontScale,
    required String notificationTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    await prefs.setString('accent', accent);
    await prefs.setDouble('fontScale', fontScale);
    await prefs.setString('notificationTime', notificationTime);
  }

  /// Load settings from local storage
  Future<Map<String, dynamic>> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'theme': prefs.getString('theme') ?? 'system',
      'accent': prefs.getString('accent') ?? 'blue',
      'fontScale': prefs.getDouble('fontScale') ?? 1.0,
      'notificationTime': prefs.getString('notificationTime') ?? '08:00',
    };
  }

  /// Sync settings to Supabase user_profiles table
  Future<void> syncRemote() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return;

    await _db.from('user_profiles').upsert({
      'user_id': uid,
      'theme': prefs.getString('theme') ?? 'system',
      'accent': prefs.getString('accent') ?? 'blue',
      'font_scale': prefs.getDouble('fontScale') ?? 1.0,
      'notification_time': prefs.getString('notificationTime') ?? '08:00',
    });
  }

  /// Load settings from Supabase and update local storage
  Future<void> loadRemote() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return;
    final res = await _db
        .from('user_profiles')
        .select('*')              // 👈 FIXED
        .eq('user_id', uid)
        .maybeSingle();
    if (res != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme', res['theme'] ?? 'system');
      await prefs.setString('accent', res['accent'] ?? 'blue');
      await prefs.setDouble('fontScale', (res['font_scale'] ?? 1.0).toDouble());
      await prefs.setString('notificationTime', res['notification_time'] ?? '08:00');
    }
  }
}
