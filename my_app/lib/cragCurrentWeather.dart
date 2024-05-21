//a class that combines crag class and weather class

import 'weatherGetter.dart';
import 'cragData.dart';

class CragCurrentWeather {
  final String cragName;
  late Map<String, dynamic> cragInfo;
  late Weather weather;

  CragCurrentWeather(this.cragName);

  Future<void> initialize() async {
    final api = WeatherApi();
    Map<String, dynamic> fetchedCragInfo = CragData().get()[cragName];
    cragInfo = fetchedCragInfo;
    String location = fetchedCragInfo["location"];
    Weather fetchedWeather = await api.fetchCurrentWeather(location);
    weather = fetchedWeather;
  }
}
