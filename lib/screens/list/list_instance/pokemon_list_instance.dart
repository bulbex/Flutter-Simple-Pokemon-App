import 'package:flutter/cupertino.dart';
import 'package:pokemon_app/screens/details/pokemon_details.dart';

class PokemonListInstance extends StatelessWidget {
  final String name;
  final String detailsUri;

  const PokemonListInstance({
    super.key,
    required this.name,
    required this.detailsUri
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => PokemonDetails(detailsUri: detailsUri))
        );
      },
      child: Center(
        child: Text(name.toUpperCase()),
      ),
    );
  }
}