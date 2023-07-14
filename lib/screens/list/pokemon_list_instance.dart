import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class PokemonListInstance extends StatelessWidget {

  final String name;
  final String detailsURL;

  const PokemonListInstance({
      required this.name,
      required this.detailsURL
  });

  factory PokemonListInstance.fromJson(Map<String, dynamic> json) {
    return PokemonListInstance(name: json['name'], detailsURL: json['url']);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: null,
      child: Text(name)
    );
  }
}