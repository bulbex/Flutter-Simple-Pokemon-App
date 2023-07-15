import 'package:flutter/cupertino.dart';

class PokemonListInstance extends StatelessWidget {
  final int id;
  final String name;

  const PokemonListInstance({
    super.key,
    required this.id,
    required this.name
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      onPressed: () => '',
      child: Center(
        child: Text(name.toUpperCase()),
      ),
    );
  }
}