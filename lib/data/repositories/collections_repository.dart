import '../supabase_client.dart';

class CollectionsRepository {
  final _db = SupabaseService.client;

  Future<List<String>> getCollections() async {
    final uid = _db.auth.currentUser?.id;
    if (uid == null) return [];
    final res = await _db
        .from('collections')
        .select('name')
        .eq('user_id', uid);
    return (res as List)
        .map((row) => row['name'] as String)
        .toList();
  }

  Future<List<Map<String, dynamic>>> listCollections() async {
    final uid = _db.auth.currentUser!.id;
    final rows = await _db
        .from('collections')
        .select('id, name, collection_items(quotes(*))')
        .eq('user_id', uid);

    return rows as List<Map<String, dynamic>>;
  }

  Future<void> createCollection(String name, String quoteId) async {
    final uid = _db.auth.currentUser!.id;
    final res = await _db.from('collections').insert({
      'user_id': uid,
      'name': name,
    }).select().single();

    final collectionId = res['id'];
    await add(collectionId, quoteId);
  }

  Future<void> addToCollection(String name, String quoteId) async {
    final uid = _db.auth.currentUser!.id;
    final res = await _db
        .from('collections')
        .select('id')
        .eq('user_id', uid)
        .eq('name', name)
        .single();

    final collectionId = res['id'];
    await add(collectionId, quoteId);
  }

  Future<void> add(String collectionId, String quoteId) async {
    await _db.from('collection_items').insert({
      'collection_id': collectionId,
      'quote_id': quoteId,
    });
  }
}
