class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> obj) {
    return Band(
      id: obj['id'] ?? '', // Valor por defecto si es null
      name: obj['name'] ?? 'Unknown', // Valor por defecto si es null
      votes: obj['votes'] ?? 0, // Valor por defecto si es null
    );
  }
}
