import 'package:weather_app/model/weather.dart';
import 'package:weather_app/service/weatherService.dart';


class WeatherController {
  final WeatherService _weatherService = WeatherService();

  Future<List<Weather>> fetchWeatherData(String city) async {
    final Map<String, dynamic> weatherData = await _weatherService.fetchWeatherData(city);
    final List<dynamic> forecasts = weatherData['list'];

    return forecasts.map((forecast) => Weather.fromJson(forecast)).toList();
  }
}
