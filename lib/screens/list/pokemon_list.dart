import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:pokemon_app/screens/list/list_instance/pokemon_list_instance.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  PokemonListState createState() => PokemonListState();
}

class PokemonListState extends State<PokemonList> {
  late Future<Map<String, dynamic>> pokemonListResponse;

  late int maxCount = 0;
  late String nextPageUri = '';
  late List<dynamic> listOfPokemons = [];

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    loadPokemons("https://pokeapi.co/api/v2/pokemon?limit=20");

    _setUpScrollController();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme: const CupertinoThemeData(brightness: Brightness.light),
      home: buildPokemonListView()
    );
  }

  Widget buildPokemonListView() {
    return CupertinoPageScaffold(
      child: FutureBuilder(
        future: pokemonListResponse,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator(color: CupertinoColors.black));
          }
          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(5),
            itemCount: listOfPokemons.length,
            itemBuilder: (BuildContext context, int index) {
              // Check if the user loaded all possible pokemons
              return listOfPokemons.length != maxCount && index != listOfPokemons.length - 1
              ? PokemonListInstance(id: index + 1, name: '${listOfPokemons[index]['name']}')
              // Loading indicator at the end of the list
              : const Center(child: CupertinoActivityIndicator(color: CupertinoColors.black));
            },
            separatorBuilder: (context, index) => const SizedBox(height: 5),
          );
        } 
      )
    );
  }

  void _setUpScrollController() {
    // Check if the user reached the bottom of the screen
    _scrollController.addListener(() {
      _scrollController.position.pixels == _scrollController.position.maxScrollExtent
      ? loadPokemons(nextPageUri)
      : null;
    });
  }

  void loadPokemons(String uri) {
    pokemonListResponse = fetchPokemonListData(uri);
    
    pokemonListResponse.then((response) {
      setState(() {
        maxCount = response['count'];
        nextPageUri = response['next'];
        listOfPokemons.addAll(response['results']);
      });
    });
  }
}

Future<Map<String, dynamic>> fetchPokemonListData(String uri) async {
  final response = await http.get(Uri.parse(uri));

  return jsonDecode(response.body);
}