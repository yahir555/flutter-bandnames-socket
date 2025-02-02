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
      id    :obj.containsKey('id') ?   obj['id']: 'no-id', // Valor por defecto si es null
      name  :obj.containsKey('name')?  obj['name']: 'no-name', // Valor por defecto si es null
      votes :obj.containsKey('votes')? obj['votes']: 'no-votes'// Valor por defecto si es null
    );
  }
}
