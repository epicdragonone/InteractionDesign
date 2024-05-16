import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PastWeather {
  final String localTime;
  final String locationName;
  final String region;
  final String country;
  final double tempC;
  final String conditionText;
  final double windKph;
  final int humidity;
  final double feelslikeC;

  const PastWeather({
    required this.localTime,
    required this.locationName,
    required this.region,
    required this.country,
    required this.tempC,
    required this.conditionText,
    required this.windKph,
    required this.humidity,
    required this.feelslikeC,
  });

  factory PastWeather.fromJson(Map<String, dynamic> json) {
    return PastWeather(
      locationName: json['location']['name'] as String,
      region: json['location']['region'] as String,
      country: json['location']['country'] as String,
      localTime: json['forecast']['hour']['time'] as String,
      tempC: (json['forecast']['hour']['temp_c'] as num).toDouble(),
      conditionText: json['forecast']['hour']['condition']['text'] as String,
      windKph: (json['forecast']['hour']['wind_kph'] as num).toDouble(),
      humidity: json['forecast']['hour']['humidity'] as int,
      feelslikeC: (json['forecast']['hour']['feelslike_c'] as num).toDouble(),
    );
  }
}

class PastApi {
  final String apiKey;
  final String baseUrl;

  PastApi({required this.apiKey, this.baseUrl = 'http://api.weatherapi.com/v1'});

  Future<PastWeather> fetchWeather(String query, DateTime dt, int hour) async {
    final response = await http.get(
      Uri.parse('$baseUrl/history.json?key=$apiKey&q=$query&dt=$dt&hour=$hour'),
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      try {
        return PastWeather.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
      } catch (e) {
        print('Error during parsing: $e');
        throw Exception('Failed to parse weather data');
      }
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}