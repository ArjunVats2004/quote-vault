class Quote {
  final String id;
  final String text;
  final String author;
  final String category;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });

  // Factory to create Quote from Supabase JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
    );
  }

  // Convert Quote back to JSON (useful for inserts/updates)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
    };
  }
}
