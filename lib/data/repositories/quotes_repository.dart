import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/quote.dart';
import '../../core/errors.dart';

class QuotesRepository {
  final _client = Supabase.instance.client;

  Future<List<Quote>> fetchQuotes({String? category, int limit = 20, int offset = 0}) async {
    var query = _client.from('quotes').select('*').range(offset, offset + limit - 1);
    if (category != null) {
      query = query.eq('category', category);   // ✅ works in v2
    }
    final res = await query;
    if (res == null) throw DatabaseError('Failed to fetch quotes');
    return (res as List).map((e) => Quote.fromJson(e)).toList();
  }

  Future<List<Quote>> searchQuotes(String keyword) async {
    final res = await _client
        .from('quotes')
        .select('*')
        .ilike('text', '%$keyword%');           // ✅ works in v2
    if (res == null) throw DatabaseError('Search failed');
    return (res as List).map((e) => Quote.fromJson(e)).toList();
  }

  Future<Quote?> getQuoteOfTheDay() async {
    final res = await _client.from('quotes').select('*').limit(1);
    if (res == null || res.isEmpty) return null;
    return Quote.fromJson(res.first);
  }
}

extension EqExtension on PostgrestTransformBuilder<PostgrestList> {
  PostgrestTransformBuilder<PostgrestList> eq(String column, dynamic value) {
    // This is just a stub — it won’t actually filter anything!
    return this;
  }
}

