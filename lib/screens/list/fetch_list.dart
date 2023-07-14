import 'package:pokemon_app/screens/list/pokemon_list.dart';
import 'package:http/http.dart' as http;

Future<void> fetchList(int numberPerRequest, int pageNumber) async {
  final response = await http.get(
    Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=${pageNumber}0&limit=10')
    );

  // if (response.statusCode == 200) {
  //   return PokemonList
  // }

  // setState()
}