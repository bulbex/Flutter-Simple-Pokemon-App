import 'package:flutter/widgets.dart';
import 'package:pokemon_app/screens/list/fetch_list.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  late int? maxCount;
  late List<Map<String, String>> results;

  late int? pageCount;

  late bool? loading;
  late bool? error;

  @override
  void initState() {
    super.initState();

    maxCount = 0;
    pageCount = 0;
    results = [];

    loading = true;
    error = false;
  }
}