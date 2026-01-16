import 'package:flutter/material.dart';
import '../domain/models/quote.dart';
import '../data/repositories/favorites_repository.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;
  const QuoteCard({super.key, required this.quote});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    isFav = await FavoritesRepository().isFavorited(widget.quote.id);
    setState(() {});
  }

  Future<void> _toggleFavorite() async {
    await FavoritesRepository().toggleFavorite(widget.quote.id);
    _checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: Text(widget.quote.text),
        subtitle: Text(widget.quote.author),
        trailing: IconButton(
          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          color: isFav ? Colors.red : null,
          onPressed: _toggleFavorite,
        ),
      ),
    );
  }
}
