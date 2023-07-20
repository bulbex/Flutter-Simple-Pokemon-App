import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/database/database.dart';
import 'package:pokemon_app/screens/details/pokemon_details.dart';
import 'package:pokemon_app/screens/list/list_instance/pokemon_list_instance.dart';
import 'package:pokemon_app/utils/network_connection.dart';
import 'package:pokemon_app/screens/error/error_widget.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  PokemonListState createState() => PokemonListState();
}

class PokemonListState extends State<PokemonList> {

  late int maxCount = 0;
  late String nextPageUri = '';
  late List<dynamic> listOfPokemons = [];

  final _scrollController = ScrollController();

  bool error = false;
  bool loading = true;
  bool offline = false;

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
      navigationBar: const CupertinoNavigationBar(
        transitionBetweenRoutes: false,
        backgroundColor: CupertinoColors.extraLightBackgroundGray,
        middle: Text('SIMPLE POKEMON APP'),
      ),
      child: Builder(
        builder: (context) {
          if (loading) return const Center(child: CupertinoActivityIndicator(color: CupertinoColors.black));
          // Error on first load attempt
          if (error && listOfPokemons.isEmpty) return const MyErrorWidget(errorMessage: 'An error occured while loading pokemons.\n');
          
          return ListView.separated(
              controller: _scrollController,
              padding: const EdgeInsets.all(5),
              itemCount: listOfPokemons.length,
              itemBuilder: (BuildContext context, int index) {
                String pokemonName = '${listOfPokemons[index]['name']}';
                String pokemonDetailsUri = '${listOfPokemons[index]['url']}';

                Widget pokemonListInstance = CupertinoButton.filled(
                  onPressed: () {
                    var listInstance = context.read<PokemonListInstance>();

                    listInstance.click(pokemonName, pokemonDetailsUri);

                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => PokemonDetails(
                        name: pokemonName, 
                        detailsUri: pokemonDetailsUri
                        )
                      )
                    );
                  },
                  child: Center(
                    child: Text(pokemonName.toUpperCase()),
                  ),
                );
                
                // Shows last visited pokemon via [Consumer] widget
                if (index == 0) {
                  return Column(children: [
                    Consumer<PokemonListInstance>(
                      builder: (context, instance, child) => Center(
                        child: instance.pokemonName != ''
                        ? Text('Last time you visited ${instance.pokemonName.toUpperCase()}!', 
                          style: const TextStyle(color: CupertinoColors.activeBlue))
                        : const Text('You haven`t visited any Pokemon!', 
                          style: TextStyle(color: CupertinoColors.activeBlue))
                      )
                    ),
                    const SizedBox(height: 5),
                    pokemonListInstance
                    ]
                  );
                }

                if (index != listOfPokemons.length - 1) {
                  return pokemonListInstance;
                }
                // Last element with loading indicator for pagination,
                // if the user did not loaded all possible pokemons
                return listOfPokemons.length != maxCount 
                ? Column(
                    children: [
                      pokemonListInstance,
                      const SizedBox(height: 8),
                      // Pagination error
                      !error 
                      ? const Center(child: CupertinoActivityIndicator(color: CupertinoColors.black))
                      : const Center(child: Text('An error occured while loading pokemons :('))
                  ],)
                : pokemonListInstance;
              },
              separatorBuilder: (context, index) => const SizedBox(height: 5),
            );
        } 
      )
    );
  }

  void _setUpScrollController() {
    // Check if the user reached the bottom of the screen
    // and loaded all possible pokemons
    _scrollController.addListener(() {
      listOfPokemons.length != maxCount &&
      _scrollController.position.pixels == _scrollController.position.maxScrollExtent
      ? loadPokemons(nextPageUri)
      : null;
    });
  }

  void loadPokemons(String uri) async {
    if (await checkConnection() == true) {
      fetchPokemonListData(uri)
      .then((response) {
        setState(() {
          loading = false;
          maxCount = response['count'];
          nextPageUri = response['next'];
          listOfPokemons.addAll(response['results']);
        });
      })
      .catchError((e) {
        setState(() {
          loading = false;
          error = true;
        });
      });
      return;
    }
    PokemonDatabaseHelper.getPokemonsName()
    .then((result) {
      if (result.isEmpty) {
        setState(() {
          loading = false;
          error = true;
        });
        return;
      }
      setState(() {
        loading = false;
        maxCount = result.length;
        listOfPokemons.addAll(result);
      });
    });
  }
}

Future<Map<String, dynamic>> fetchPokemonListData(String uri) async {
  final response = await http.get(Uri.parse(uri));

  return jsonDecode(response.body);
}