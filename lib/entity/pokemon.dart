class Pokemon {
  final String name;
  final String photoUri;
  final List<dynamic> types;
  final int weight;
  final int height;

  Pokemon({
    required this.name,
    required this.photoUri,
    required this.types,
    required this.weight,
    required this.height
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      photoUri: json['sprites']['front_default'],
      types: json['types'].map((type) => type['type']['name']).toList(),
      weight: json['weight'],
      height: json['height']
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'types': types,
  //     'weight': weight,
  //     'height': height
  //   };
  // }

  // @override
  // String toString() {
  //   return 'Pokemon{name: $name, types: $types, weight: $weight, height: $height}';
  // }
}