class Weather {
  final String? location;
  final String? description;
  final double? temperature;
  final double? minTemperature;
  final double? maxTemperature;

  Weather({
     this.location,
     this.description,
     this.temperature,
     this.minTemperature,
     this.maxTemperature,
  });
factory Weather.fromJson(Map<String, dynamic> json) {
  return Weather(
    location: json['name'] != null && json['sys'] != null && json['sys']['country'] != null
        ? '${json['name']}, ${json['sys']['country']}'
        : 'Unknown Location',
    description: json['weather'] != null && json['weather'].isNotEmpty && json['weather'][0]['description'] != null
        ? json['weather'][0]['description']
        : 'Unknown Description',
    temperature: json['main'] != null && json['main']['temp'] != null
        ? json['main']['temp'] - 273.15
        : 0.0,
    minTemperature: json['main'] != null && json['main']['temp_min'] != null
        ? json['main']['temp_min'] - 273.15
        : 0.0,
    maxTemperature: json['main'] != null && json['main']['temp_max'] != null
        ? json['main']['temp_max'] - 273.15
        : 0.0,
  );
}

}
