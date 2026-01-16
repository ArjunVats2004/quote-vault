import '../supabase_client.dart';
import '../../domain/models/quote.dart';

class FavoritesRepository {
  final _db = SupabaseService.client;

  Future<bool> isFavorited(String quoteId) async {
    final uid = _db.auth.currentUser!.id;
    final res = await _db
        .from('user_favorites')
        .select('id')                       // 👈 explicit column selection
        .eq('user_id', uid)                 // 👈 use eq()
        .eq('quote_id', quoteId)            // 👈 use eq()
        .maybeSingle();
    return res != null;
  }

  Future<void> toggleFavorite(String quoteId) async {
    final uid = _db.auth.currentUser!.id;
    final exists = await isFavorited(quoteId);
    if (exists) {
      await _db
          .from('user_favorites')
          .delete()
          .eq('user_id', uid)               // 👈 use eq()
          .eq('quote_id', quoteId);         // 👈 use eq()
    } else {
      await _db.from('user_favorites').insert({
        'user_id': uid,
        'quote_id': quoteId,
      });
    }
  }

  Future<List<Quote>> list() async {
    final uid = _db.auth.currentUser!.id;
    final rows = await _db
        .from('user_favorites')
        .select('quotes:quote_id(*)')       // 👈 explicit column selection
        .eq('user_id', uid);                // 👈 use eq()
    return (rows as List)
        .map((e) => Quote.fromJson(e['quotes']))
        .toList();
  }
}
