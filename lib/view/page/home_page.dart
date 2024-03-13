import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String iconUrl = "http://openweathermap.org/img/wn/";
  static const String baseUrl = "https://api.openweathermap.org/data/2.5";
  static const String apiKey = "appid=22bfb3717e47c1f1b611d99cc777c9f8";
  Map<String, List<double>> _dailyTemperatures = {};
  var weatherData;
  var temperature;
  var description;
  Map<String, dynamic> _dailyIcons = {};
  late String iconCode;
  TextEditingController _cityController = TextEditingController();

  bool isDarkMode = false; // Variable to track the mode

  Future<void> fetchWeatherData(String city) async {
    final response =
        await http.get(Uri.parse('$baseUrl/forecast?q=$city&$apiKey'));

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
        description = weatherData['list'][0]['weather'][0]['description'];
        temperature = weatherData['list'][0]['main']['temp_min'] - 273.15;
        iconCode = weatherData['list'][0]['weather'][0]['icon'];

        print(weatherData['list']);

        for (var forecast in weatherData['list']) {
          final DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          final String day = DateFormat('EEEE').format(dateTime);

          double _tempMin = forecast['main']['temp_min'] - 273.15;
          double _tempMax = forecast['main']['temp_max'] - 273.15;
          _dailyIcons[day] = forecast['weather'][0]['icon'];
          _dailyTemperatures[day] = [_tempMin, _tempMax];
        }
        print(_dailyIcons.length);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Weather data loaded successfully for $city',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to load weather data for city: $city'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(
          Icons.menu,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: TextField(
          controller: _cityController,
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.3),
          decoration: InputDecoration(
            labelText: 'Enter City',
            labelStyle: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18,
               ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                weatherData = null;
                temperature = null;
                fetchWeatherData(_cityController.text);
                setState(() {
                  // print(weatherData);
                });
              },
            ),
          ),
        ),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
            activeColor: Colors.blue,
            inactiveThumbColor: Colors.grey,
          ),
        ],
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Container(
          color: isDarkMode ? Colors.black : Colors.white,
          child: Column(
            children: [
              weatherData == null
                  ? Text('')
                  : Expanded(
                      flex: 1,
                      child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Center(
                                  child: Text(
                                    _cityController.text,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 30,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey
                                          : Colors.black.withOpacity(.5),
                                      fontSize: 25,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${temperature.toStringAsFixed(0)}°C',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.deepPurpleAccent,
                                      fontSize: 40,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                Divider(
                                    color: Colors.black.withOpacity(.3),
                                    endIndent: 100,
                                    indent: 100),
                                Center(
                                  child: Text(
                                    description,
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey
                                          : Colors.black.withOpacity(.5),
                                      fontSize: 25,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Wrap(
                                      alignment: WrapAlignment.center,
                                      children: [
                                        Text(
                                          '${(weatherData['list'][0]['main']['temp_min'] - 273.15).toStringAsFixed(0)}°C',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.1,
                                          ),
                                        ),
                                        Text(
                                          '/${(weatherData['list'][0]['main']['temp_max'] - 273.15).toStringAsFixed(0)}°C',
                                          style: TextStyle(
                                            color: Colors.deepPurpleAccent,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.1,
                                          ),
                                        )
                                      ]),
                                ),
                              ],
                            );
                          }),
                    ),
              weatherData == null
                  ? Center(child: Text(''))
                  : Container(
                      padding: EdgeInsets.all(5),
                      height: 230,
                      decoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey.withOpacity(.2)
                              : Colors.grey.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Forecast for today',
                            style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: weatherData['list'][0].length,
                                itemBuilder: (context, index) {
                                  var _forecast = weatherData['list'][index];
                                  final String _iconUrl =
                                      "http://openweathermap.org/img/wn/$iconCode.png";
                                  return Column(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                      ),
                                      Text(
                                        _forecast['dt_txt']
                                            .toString()
                                            .substring(11, 16),
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Image.network(
                                        _iconUrl,
                                        color:isDarkMode? Colors.white:Colors.black,
                                        width: 30,
                                      ),
                                      Text(
                                        '${(_forecast['main']['temp_max'] - 273.15).toStringAsFixed(0)}°C',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Image.asset(
                                        'assets/wind.png',
                                        width: 30,
                                      ),
                                      Text(
                                        '${(_forecast['wind']['speed'].toStringAsFixed(0))}Km/h',
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Image.asset(
                                        'assets/umbrella.png',
                                        width: 30,
                                      ),
                                      Text(
                                        '${(_forecast['wind']['deg'].toStringAsFixed(0))}%',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '7-day forecast',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 1.1,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Min',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Max',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Divider(),
                ],
              ),
              Divider(),
              Expanded(
                child: weatherData == null
                    ? Text('')
                    : ListView.builder(
                        itemCount: _dailyTemperatures.length,
                        itemBuilder: (context, index) {
                          var days = _dailyTemperatures.keys.toList();
                          print(_dailyTemperatures.length);
                          String day = days[index];
                          double? _tempMin = _dailyTemperatures[day]?.first;
                          double? _tempMax = _dailyTemperatures[day]?.last;
                          String _iconCode = _dailyIcons[day];
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  index == 0
                                      ? Text(
                                          "Today",
                                          style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )
                                      : Text(
                                          day.substring(0, 3) + "   ",
                                          style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                  Shimmer.fromColors(
                                    baseColor: isDarkMode?Colors.white:Colors.lightBlueAccent,
                                    highlightColor: Colors.blue,
                                    child: Image.network(
                                      '$iconUrl$_iconCode.png',
                                      width: 40,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    " ${_tempMin!.toStringAsFixed(0)}°C",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey
                                          : Colors.black.withOpacity(.5),
                                      fontSize: 20,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  Text(
                                    " ${_tempMax!.toStringAsFixed(0)}°C",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
