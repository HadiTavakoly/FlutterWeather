import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/current_weather_model.dart';

Future<CurrentWeather> getCurrentWeather(String q) async {
  var queryParameters = {
    'key': '1100b041954e4c40808145513220712',
    'q': q,
    'aqi': 'yes',
  };
  var respons = await http.get(
    Uri.http('api.weatherapi.com', 'v1/forecast.json', queryParameters),
  );

  if (respons.statusCode == 200) {
    return CurrentWeather.fromJson(jsonDecode(respons.body));
  } else {
    throw Exception('Fail to load current weather');
  }
}
