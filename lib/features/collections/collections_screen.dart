import 'package:flutter/material.dart';
import '../../data/repositories/collections_repository.dart';

class CollectionsScreen extends StatefulWidget {
  const CollectionsScreen({super.key});

  @override
  State<CollectionsScreen> createState() => _CollectionsScreenState();
}

class _CollectionsScreenState extends State<CollectionsScreen> {
  final repo = CollectionsRepository();
  List<Map<String, dynamic>> collections = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      final data = await repo.listCollections();
      setState(() {
        collections = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading collections: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (collections.isEmpty) {
      return Scaffold(
        backgroundColor: primary,
        body: const Center(
          child: Text(
            'No collections yet',
            style: TextStyle(color: Colors.orange, fontSize: 25),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        title: const Text('Collections', style: TextStyle(color: Colors.white)),
        backgroundColor: primary,
      ),
      body: ListView(
        children: collections.map((entry) {
          final name = entry['name'];
          final items = entry['collection_items'] as List<dynamic>;
          return ExpansionTile(
            title: Text(
              name,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: items.map((item) {
              final q = item['quotes'];
              return ListTile(
                title: Text(
                  q['text'],
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                subtitle: Text(
                  q['author'],
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
