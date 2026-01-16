import 'package:flutter/material.dart';
import '../../domain/models/quote.dart';

class QuoteList extends StatelessWidget {
  final List<Quote> quotes;
  final void Function(Quote) onTap;

  const QuoteList({super.key, required this.quotes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: quotes.length,
      itemBuilder: (context, index) {
        final q = quotes[index];
        return ListTile(
          title: Text(q.text),
          subtitle: Text(q.author ?? 'Unknown'),
          onTap: () => onTap(q),
        );
      },
    );
  }
}
