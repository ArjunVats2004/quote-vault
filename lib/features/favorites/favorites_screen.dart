import 'package:flutter/material.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../domain/models/quote.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final repo = FavoritesRepository();
  List<Quote> quotes = []; List<Quote> favorites = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await repo.list();
      setState(() {
        favorites = favs;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorites: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorites yet',
          style: TextStyle(color: Colors.orange, fontSize: 20),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, i) {
          final q = favorites[i];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            color: primary.withOpacity(0.8),
            child: ListTile(
              title: Text(
                q.text,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18),
              ),
              subtitle: Text(
                q.author,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 16),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await repo.toggleFavorite(q.id);
                  _loadFavorites(); // refresh after removal
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
