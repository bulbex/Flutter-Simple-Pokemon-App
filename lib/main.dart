import 'package:flutter/widgets.dart';
import 'package:pokemon_app/screens/list/pokemon_list.dart';

void main() {
  runApp(const PokemonApp());
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PokemonList();
  }
}