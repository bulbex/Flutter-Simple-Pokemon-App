import 'package:flutter/cupertino.dart';

class PokemonListInstance with ChangeNotifier {
  String pokemonName = '';
  String pokemonDetailsUri = '';

  void click(String name, String detailsUri) {
    pokemonName = name;
    pokemonDetailsUri = detailsUri;
    notifyListeners();
  }
}