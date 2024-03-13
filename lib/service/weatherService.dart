import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";
  static const String apiKey = "appid=22bfb3717e47c1f1b611d99cc777c9f8"; // Add your API key here

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final response = await http.get(Uri.parse('$baseUrl/forecast?q=giza&$apiKey'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
