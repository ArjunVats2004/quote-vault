import 'package:flutter/material.dart';

class CollectionDetailScreen extends StatefulWidget {
  final String name;
  final List<Map<String, dynamic>> quotes;

  const CollectionDetailScreen({super.key, required this.name, required this.quotes});

  @override
  State<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends State<CollectionDetailScreen> {
  late List<Map<String, dynamic>> collectionQuotes = [];
@override
void initState(){
  super.initState();
  collectionQuotes=List<Map<String,dynamic>>.from(widget.quotes);
}
  void _addQuote(Map<String, dynamic> quote) {
    setState(() {
      collectionQuotes.add(quote);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: ListView.builder(
        itemCount: collectionQuotes.length,
        itemBuilder: (context, i) {
          final q = collectionQuotes[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ListTile(
              title: Text(q['text'],style: TextStyle(color: Colors.white,fontSize: 20),),
              subtitle: Text(q['author'],style: TextStyle(color: Colors.white,fontSize: 20)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // For now, just pick the first quote as demo
          if (widget.quotes.isNotEmpty) {
            _addQuote(widget.quotes.first);
          }
        },
      ),
    );
  }
}
