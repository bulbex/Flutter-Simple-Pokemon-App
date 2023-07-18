import 'dart:io';

import 'package:http/http.dart' as http;

Future<bool> checkConnection() async {
  try {
    final result = await http.get(Uri.parse('http://example.com'));
    return result.statusCode == 200 ? true : false;
  } on SocketException catch (_) {
    return false;
  }
}
