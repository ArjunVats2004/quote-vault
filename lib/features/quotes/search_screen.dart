import 'package:flutter/material.dart';
import 'package:quote_vault/features/quotes/quote_list.dart';
import '../../data/repositories/quotes_repository.dart';
import '../../domain/models/quote.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _repo = QuotesRepository();
  final _controller = TextEditingController();
  List<Quote> _results = [];
  bool _loading = false;

  Future<void> _search() async {
    setState(() => _loading = true);
    final res = await _repo.searchQuotes(_controller.text);
    setState(() {
      _results = res;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Quotes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter keyword',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : QuoteList(quotes: _results, onTap: (q) {}),
          ),
        ],
      ),
    );
  }
}
