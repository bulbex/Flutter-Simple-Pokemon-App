import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/database/database.dart';
import 'package:pokemon_app/entity/pokemon.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/screens/error/error_widget.dart';

class PokemonDetails extends StatefulWidget {
  const PokemonDetails({
    super.key, 
    required this.name, 
    required this.detailsUri
  });

  final String name;
  final String detailsUri;

  @override
  PokemonDetailsState createState() => PokemonDetailsState();
}

class PokemonDetailsState extends State<PokemonDetails> {
  late Future<Pokemon> _futurePokemon;

  @override
  void initState() {
    super.initState();

    _futurePokemon = loadPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        leading: CupertinoNavigationBarBackButton(
          previousPageTitle: 'Back',
          onPressed: () => Navigator.pop(context),
        ),
        middle: Text(widget.name.toUpperCase()),
      ),
      child: FutureBuilder(
        future: _futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.hasError) return MyErrorWidget(errorMessage: 'An error occured while loading ${widget.name.toUpperCase()} details.');
          if (!snapshot.hasData) return const Center(child: CupertinoActivityIndicator(color: CupertinoColors.black));
          return Column(children: [
            Center(
              child: Image.memory(base64Decode(snapshot.data!.photo), scale: 0.5)
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Table(
                border: TableBorder.all(
                  color: CupertinoColors.activeBlue, 
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                children: <TableRow>[
                  TableRow(
                    children: <Widget>[
                      _tableCell('TYPES'),
                      _tableCell('WEIGHT'),
                      _tableCell('HEIGHT')
                    ]
                  ),
                  TableRow(
                    children: <Widget>[
                      _tableCell(snapshot.data!.types.join(", ")),
                      _tableCell('${snapshot.data!.weight / 10} kg'),
                      _tableCell('${snapshot.data!.height * 10} cm')
                    ]
                  )
                ])
            )
          ]);
        }
      )
    );
  }

  static Widget _tableCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5),
      child: Text(text, style: const TextStyle(fontSize: 20))
    );
  }

  Future<Pokemon> loadPokemon() async {
    var result = await PokemonDatabaseHelper.getPokemon(widget.name);
    if (result.isNotEmpty) {
      var pokemon = result[0];
      return Pokemon(
        name: pokemon['name'], 
        photo: pokemon['photo'], 
        types: pokemon['types'].split(','), 
        weight: pokemon['weight'], 
        height: pokemon['height']
      );
    }
    return fetchPokemon(widget.name, widget.detailsUri);
  }
}

Future<Pokemon> fetchPokemon(String name, String uri) async {
  final response = await http.get(Uri.parse(uri));
  final pokemonData = jsonDecode(response.body);

  final pokemonPhoto = await http.get(Uri.parse(pokemonData['sprites']['front_default']));
  var base64Photo = base64Encode(pokemonPhoto.bodyBytes);

  var pokemon = Pokemon(
    name: pokemonData['name'],
    photo: base64Photo,
    types: pokemonData['types'].map((type) => type['type']['name']).toList(),
    weight: pokemonData['weight'],
    height: pokemonData['height']
  );

  await PokemonDatabaseHelper.insertPokemon(
    pokemon.name,
    pokemon.photo,
    pokemon.types,
    pokemon.weight,
    pokemon.height
  );

  return pokemon;
}