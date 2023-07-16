import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/entity/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonDetails extends StatefulWidget {
  const PokemonDetails({super.key, required this.detailsUri});

  final String detailsUri;

  @override
  PokemonDetailsState createState() => PokemonDetailsState();
}

class PokemonDetailsState extends State<PokemonDetails> {
  late Future<Pokemon> _futurePokemon;

  @override
  void initState() {
    super.initState();

    _futurePokemon = fetchPokemon(widget.detailsUri);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futurePokemon,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(),
            child: Center(child: Text(snapshot.data!.name))
          );
        }
        return const Text('Something happened');
      }
    );
  }
}

Future<Pokemon> fetchPokemon(String uri) async {
  final response = await http.get(Uri.parse(uri));

  return Pokemon.fromJson(jsonDecode(response.body));
}