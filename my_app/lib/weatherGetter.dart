import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  final String localTime;
  final String locationName;
  final String region;
  final String country;
  final double tempC;
  final String conditionText;
  final double windKph;
  final int humidity;
  final double feelslikeC;
  final String iconUrl; //add this to show weather icon

  const Weather({
    required this.localTime,
    required this.locationName,
    required this.region,
    required this.country,
    required this.tempC,
    required this.conditionText,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    var firstHour = json['forecast']['forecastday'][0]['hour'][0];
    return Weather(
        locationName: json['location']['name'] as String,
        region: json['location']['region'] as String,
        country: json['location']['country'] as String,
        localTime: (firstHour['time']) as String,
        tempC: (firstHour['temp_c'] as num).toDouble(),
        conditionText: firstHour['condition']['text'] as String,
        windKph: (firstHour['wind_kph'] as num).toDouble(),
        humidity: firstHour['humidity'] as int,
        feelslikeC: (firstHour['feelslike_c'] as num).toDouble(),
        iconUrl: 'https:${firstHour['condition']['icon']}', //icon
    );
  }
  factory Weather.fromJsonCurrent(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'] as String,
      region: json['location']['region'] as String,
      country: json['location']['country'] as String,
      localTime: json['location']['localtime'] as String,
      tempC: (json['current']['temp_c'] as num).toDouble(),
      conditionText: json['current']['condition']['text'] as String,
      windKph: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'] as int,
      feelslikeC: (json['current']['feelslike_c'] as num).toDouble(),
      iconUrl: 'https:${json['current']['condition']['icon']}', //icon
    );
  }
    factory Weather.fromJsonDay(Map<String, dynamic> json, int hour) {
    var firstHour = json['forecast']['forecastday'][0]['hour'][hour];
    return Weather(
        locationName: json['location']['name'] as String,
        region: json['location']['region'] as String,
        country: json['location']['country'] as String,
        localTime: (firstHour['time']) as String,
        tempC: (firstHour['temp_c'] as num).toDouble(),
        conditionText: firstHour['condition']['text'] as String,
        windKph: (firstHour['wind_kph'] as num).toDouble(),
        humidity: firstHour['humidity'] as int,
        feelslikeC: (firstHour['feelslike_c'] as num).toDouble(),
        iconUrl: 'https:${firstHour['condition']['icon']}', //icon:
    );
  }
}


class WeatherApi {
  final String apiKey;
  final String baseUrl;

  WeatherApi({this.apiKey = 'ebd60c5ee10a4d76ac4140717241405 ', this.baseUrl = 'http://api.weatherapi.com/v1'});

  Future<Weather> fetchCurrentWeather(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current.json?key=$apiKey&q=$query&aqi=no'),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      try {
        return Weather.fromJsonCurrent(jsonDecode(response.body) as Map<String, dynamic>);
      } catch (e) {
        print('Error during parsing: $e');
        throw Exception('Failed to parse weather data');
      }
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Weather> fetchWeather(String query, String dt, int hour, String type) async {
    if (type != 'forecast' && type != 'history') {
      throw Exception("Invalid type, must be 'forecast' or 'history'");
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$type.json?key=$apiKey&q=$query&dt=$dt&hour=$hour'),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      try {
        return Weather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } catch (e) {
        print('Error during parsing: $e');
        throw Exception('Failed to parse weather data');
      }
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  Future<List<Weather>> fetchWeatherDay(String query, String dt) async {
    List<Weather> result = [];
    final response = await http.get(
      Uri.parse('$baseUrl/history.json?key=$apiKey&q=$query&dt=$dt'),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      try {
        for (int i = 0; i<24; i++)
        {
          result.add(Weather.fromJsonDay(jsonDecode(response.body) as Map<String, dynamic>, i));
        }
        return result;
        } catch (e) {
        print('Error during parsing: $e');
        throw Exception('Failed to parse weather data');
      }
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
