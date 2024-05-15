import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Weather {
  final String locationName;
  final String region;
  final String country;
  final String localtime;
  final double tempC;
  final String conditionText;
  final double windKph;
  final int humidity;
  final double feelslikeC;
  final int uv;

  const Weather({
    required this.locationName,
    required this.region,
    required this.country,
    required this.localtime,
    required this.tempC,
    required this.conditionText,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
    required this.uv,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'] as String,
      region: json['location']['region'] as String,
      country: json['location']['country'] as String,
      localtime: json['location']['localtime'] as String,
      tempC: (json['current']['temp_c'] as num).toDouble(),
      conditionText: json['current']['condition']['text'] as String,
      windKph: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'] as int,
      feelslikeC: (json['current']['feelslike_c'] as num).toDouble(),
      uv: (json['current']['uv'] as num).toInt(),
    );
  }
}

class WeatherApi {
  final String apiKey;
  final String baseUrl;

  WeatherApi({required this.apiKey, this.baseUrl = 'http://api.weatherapi.com/v1'});

  Future<Weather> fetchWeather(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/current.json?key=$apiKey&q=$query&aqi=no'),
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
}