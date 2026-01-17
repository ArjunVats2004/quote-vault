import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/collections_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/supabase_client.dart';
import '../../main.dart';
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
  String _qid(dynamic raw) => raw.toString();
  late List<Widget Function()> _screenBuilders;

  @override
  void initState() {
    super.initState();
    _screenBuilders = [
          () => _buildQuotesList(),
          () => const FavoritesScreen(),
          () => const CollectionsScreen(),
          () => const SettingsScreen(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadFavorites();
      _loadQuotes();
    });
  }

  Future<void> _loadFavorites() async {
    try {
      final favs = await FavoritesRepository().list();
      if(!mounted)return;
      setState(() {
        favorites = favs.map((q) => q.id.toString()).toSet();
      });
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _loadQuotes() async {
    setState(() => loading = true);
    try {
      final res = await SupabaseService.client.rpc(
        'get_random_quotes',
        params: {'count': 20},
      );

      debugPrint('Quotes fetched: $res');
      if (!mounted) return;
      setState(() {
        quotes = List<Map<String, dynamic>>.from(res);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading quotes: $e')));
      }
    }
  }

  Future<void> _addToCollection(Map<String, dynamic> quote) async {
    final existingCollections = await CollectionsRepository().getCollections();
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add to Collection'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (existingCollections.isNotEmpty)
                  ...existingCollections.map(
                        (name) => ListTile(
                      title: Text(name),
                      onTap: () async {
                        await CollectionsRepository().addToCollection(
                          name,
                          quote['id'].toString(),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                const Divider(),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'New collection name',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await CollectionsRepository().createCollection(
                    controller.text,
                    quote['id'].toString(),
                  );
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
    final id = q['id'].toString();

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
                favorites.contains(id) ? Icons.favorite : Icons.favorite_border,
                color: favorites.contains(id) ? Colors.red : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (favorites.contains(id)) {
                    favorites.remove(id);
                  } else {
                    favorites.add(id);
                  }
                  print("Favorites now: $favorites");
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
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your daily dose of wisdom and inspiration',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),

            // Quote text with settings applied
            Consumer<SettingsModel>(
              builder: (context, settings, child) {
                return Text(
                  '"${quote['text']}"',
                  style: TextStyle(
                    color: settings.accentColor,
                    fontSize: 24 * settings.fontScale,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),

            const SizedBox(height: 10),

            // Author text with settings applied
            Consumer<SettingsModel>(
              builder: (context, settings, child) {
                return Text(
                  '— ${quote['author']}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16 * settings.fontScale,
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Divider(
              thickness:1,
              color: Colors.grey[800],
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final id = quote['id'].toString();
                    await FavoritesRepository().toggleFavorite(id);
                    setState(() {
                      if (favorites.contains(id)) {
                        favorites.remove(id);
                      } else {
                        favorites.add(id);
                      }
                    });
                  },
                  icon: Icon(
                    favorites.contains(quote['id'].toString())
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favorites.contains(quote['id'].toString())
                        ? Colors.red
                        : Colors.white,
                  ),
                  label: Text(
                    favorites.contains(quote['id'].toString())
                        ? 'Favorited'
                        : 'Add to favorites',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton.icon(
                  onPressed: () => _addToCollection(quote),
                  icon: const Icon(Icons.add_box, color: Colors.white),
                  label: const Text(
                    'Add to collection',
                    style: TextStyle(color: Colors.white,fontSize: 16),
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
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuoteVault',
          style: TextStyle(color: Colors.orange, fontSize: 30,fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: _screenBuilders[_selectedIndex](),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D1B2A),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.orange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.collections), label: 'Collections'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
