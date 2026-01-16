import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  final client = Supabase.instance.client;

  Future<String> fetchRandomQuote() async {
    final response = await client
        .from('quotes')
        .select()
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return "Keep pushing forward!";
    }
    return response['text'] ?? "Stay inspired!";
  }
}
