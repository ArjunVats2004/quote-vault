import 'package:flutter/material.dart';
import '../../data/repositories/collections_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/supabase_client.dart';
import '../collections/collections_screen.dart';
import '../favorites/favorites_screen.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> quotes = [];
  Set<String> favorites = {};
  Map<String, List<Map<String, dynamic>>> collections = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuotes();
    });
  }

  // initialize screens
  List<Widget> get _screens => [
    _buildQuotesList(),
    const FavoritesScreen(),
    const CollectionsScreen(),
    const SettingsScreen(),
  ];

  Future<void> _loadQuotes() async {
    setState(() => loading = true);
    try {
      final res = await SupabaseService.client.rpc(
        'get_random_quotes',
        params: {'count': 20},
      );

      debugPrint('Quotes fetched: $res');

      setState(() {
        quotes = List<Map<String, dynamic>>.from(res);
        loading = false;
        // refresh home screen widget
        _screens[0] = _buildQuotesList();
      });
    } catch (e) {
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading quotes: $e')));
      }
    }
  }

  void _addToCollection(Map<String, dynamic> quote) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add to Collection'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (collections.isNotEmpty)
                ...collections.keys.map((name) => ListTile(
                  title: Text(name),
                  onTap: () async {
                    await CollectionsRepository()
                        .addToCollection(name, quote['id'].toString());
                    Navigator.pop(context);
                  },
                )),
              const Divider(),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: 'New collection name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await CollectionsRepository()
                      .createCollection(controller.text, quote['id'].toString());
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildQuoteCard(Map<String, dynamic> q) {
    final isFav = favorites.contains(q['id'].toString());

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.blueAccent, width: 1.5),
      ),
      child: ListTile(
        title: Text(
          q['text'],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(q['author']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                favorites.contains(q['id'].toString())
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    favorites.contains(q['id'].toString())
                        ? Colors.red
                        : Colors.white,
              ),
              onPressed: () {
                final id = q['id'].toString();
                setState(() {
                  if (favorites.contains(id)) {
                    favorites.remove(id);
                  } else {
                    favorites.add(id);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_box, color: Colors.blue),
              onPressed: () => _addToCollection(q),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuotesList() {
    if (loading) return const Center(child: CircularProgressIndicator());
    if (quotes.isEmpty) {
      return const Center(child: Text('No quotes available'));
    }

    final quote = quotes.first;
    final isFav = favorites.contains(quote['id'].toString());

    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your daily dose of wisdom and inspiration',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            Text(
              '"${quote['text']}"',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '— ${quote['author']}',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final id = quote['id'].toString();
                    if (favorites.contains(id)) {
                      await FavoritesRepository().toggleFavorite(id);
                      setState(() => favorites.remove(id));
                    } else {
                      await FavoritesRepository().toggleFavorite(id);
                      setState(() => favorites.add(id));
                    }
                  },
                  icon: Icon(
                    favorites.contains(quote['id'].toString())
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        favorites.contains(quote['id'].toString())
                            ? Colors.red
                            : Colors.white,
                  ),
                  label: Text(
                    favorites.contains(quote['id'].toString())
                        ? 'Favorited'
                        : 'Save to favorites',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _addToCollection(quote),
                  icon: const Icon(Icons.add_box, color: Colors.white),
                  label: const Text(
                    'Add to collection',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _loadQuotes,
              child: const Text(
                'New Quote',
                style: TextStyle(color: Colors.orange, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _screens[1] = const FavoritesScreen(); // refresh Favorites
      } else if (index == 2) {
        _screens[2] = const CollectionsScreen(); // refresh Collections
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuoteVault',
          style: TextStyle(color: Colors.orange, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
