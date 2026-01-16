class Collection {
  final String id;
  final String name;

  Collection({required this.id, required this.name});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
