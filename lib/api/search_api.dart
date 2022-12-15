import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/search_model.dart';

Future<List<Search>> search(String keyword) async {
  var queryParameters = {
    'key': '1100b041954e4c40808145513220712',
    'q': keyword,
  };
  var respons = await http.get(
    Uri.http('api.weatherapi.com', 'v1/search.json', queryParameters),
  );

  if (respons.statusCode == 200) {
    List<Search> result = List<Search>.from(
      jsonDecode(respons.body).map(
        (x) => Search.fromJson(x),
      ),
    );
    return result;
  } else {
    throw Exception('Fail to load current weather');
  }
}
