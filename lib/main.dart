import 'package:flutter/widgets.dart';
import 'package:pokemon_app/screens/list/list_instance/pokemon_list_instance.dart';
import 'package:pokemon_app/screens/list/pokemon_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => PokemonListInstance(),
      child: const PokemonApp()
    )
  );
}

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PokemonList();
  }
}