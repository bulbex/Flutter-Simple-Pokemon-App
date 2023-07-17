import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/entity/pokemon.dart';
import 'package:http/http.dart' as http;

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

    _futurePokemon = loadPokemon(widget.detailsUri);
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
          if (snapshot.hasData) {
            return Column(children: [
              Center(
                child: Image.network(snapshot.data!.photoUri, scale: 0.5)
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
          return const Text('Something happened');
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
}

Future<Pokemon> loadPokemon(String uri) async {
  final response = await http.get(Uri.parse(uri));

  return Pokemon.fromJson(jsonDecode(response.body));
}