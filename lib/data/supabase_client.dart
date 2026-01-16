import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://tctmpxtakgvwyuzrvgkv.supabase.co',
      anonKey: 'sb_publishable_05RfOS2N0vgbGgqrjnR8rQ_PNQZz22d',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
