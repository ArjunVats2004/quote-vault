import 'package:flutter/material.dart';
import '../domain/models/quote.dart';

class QuoteShareCard extends StatelessWidget {
  final Quote quote;
  final int style; // 1, 2, or 3

  const QuoteShareCard({super.key, required this.quote, this.style = 1});

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case 2:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.purple, Colors.blue]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('"${quote.text}"', style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 12),
              Text('- ${quote.author}', style: const TextStyle(color: Colors.white70)),
            ],
          ),
        );
      case 3:
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text('"${quote.text}"', style: const TextStyle(fontSize: 20, color: Colors.white)),
              const SizedBox(height: 12),
              Text('- ${quote.author}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      default:
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('"${quote.text}"', style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 12),
                Text('- ${quote.author}', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
    }
  }
}
