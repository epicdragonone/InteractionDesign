import 'package:flutter/material.dart';
import 'package:my_app/cragCurrentWeather.dart';

enum RainIntensity { dry, drizzle, moderate, heavy }

class FilterPage extends StatefulWidget {
  final Function(List<CragCurrentWeather>) onApplyButtonPressed;
  final double width;
  final List<CragCurrentWeather> data;

  const FilterPage({
    Key? key,
    required this.width,
    required this.data,
    required this.onApplyButtonPressed,
  }) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RainIntensity _currentRainIntensity = RainIntensity.dry;
  RangeValues _currentTemperatureRange = const RangeValues(-10, 45);
  RangeValues _currentWindSpeedRange = const RangeValues(0, 100);

  final List<CragCurrentWeather> filtered_data = [];

  void setFilteredData(
    List<CragCurrentWeather> data,
    RainIntensity rainIntensity,
    RangeValues temperatureRange,
    RangeValues windSpeedRange,
  ) {
    //test is filtering function works
    print(rainIntensity);
    print(temperatureRange.start.toString()+", "+temperatureRange.end.toString());
    print(windSpeedRange.start.toString()+", "+windSpeedRange.end.toString());
    List<CragCurrentWeather> dataCopy = List.from(data);

    double calculateScore(CragCurrentWeather cragWeather) {
      double score = 0;

      switch (rainIntensity) {
        case RainIntensity.dry:
          if (cragWeather.weather.precip_mm == 0) score += 10;
          break;
        case RainIntensity.drizzle:
          if (cragWeather.weather.precip_mm > 0 && cragWeather.weather.precip_mm <= 0.5) score += 10;
          break;
        case RainIntensity.moderate:
          if (cragWeather.weather.precip_mm > 0.5 && cragWeather.weather.precip_mm <= 4) score += 10;
          break;
        case RainIntensity.heavy:
          if (cragWeather.weather.precip_mm > 4) score += 10;
          break;
      }

      if (cragWeather.weather.tempC >= temperatureRange.start &&
          cragWeather.weather.tempC <= temperatureRange.end) {
        score += 10;
      }

      if (cragWeather.weather.windKph >= windSpeedRange.start &&
          cragWeather.weather.windKph <= windSpeedRange.end) {
        score += 10;
      }
    print(cragWeather.weather.precip_mm);
      return score;
    }

    dataCopy.sort((a, b) => calculateScore(b).compareTo(calculateScore(a)));
    filtered_data.clear();
    filtered_data.addAll(dataCopy);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'Filters',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RainIntensitySlider(
              title: 'Rainfall Intensity',
              initialIntensity: _currentRainIntensity,
              onChanged: (value) => setState(() {
                _currentRainIntensity = value;
              }),
            ),
            TemperatureSlider(
              title: 'Temperature (deg C)',
              initialRange: _currentTemperatureRange,
              onChanged: (value) => setState(() {
                _currentTemperatureRange = value;
              }),
            ),
            WindSpeedSlider(
              title: 'Windspeed (kph)',
              initialRange: _currentWindSpeedRange,
              onChanged: (value) => setState(() {
                _currentWindSpeedRange = value;
              }),
            ),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(5),
              ),
              onPressed: () {
                setFilteredData(
                  widget.data,
                  _currentRainIntensity,
                  _currentTemperatureRange,
                  _currentWindSpeedRange,
                );
                widget.onApplyButtonPressed(filtered_data);
              },
              child: Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}

class RainIntensitySlider extends StatelessWidget {
  final String title;
  final RainIntensity initialIntensity;
  final ValueChanged<RainIntensity> onChanged;

  RainIntensitySlider({
    required this.title,
    required this.initialIntensity,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        StatefulBuilder(
          builder: (context, setState) {
            return Slider(
              value: initialIntensity.index.toDouble(),
              onChanged: (double value) {
                setState(() {
                  final intensity = RainIntensity.values[value.toInt()];
                  onChanged(intensity);
                });
              },
              min: 0,
              max: (RainIntensity.values.length - 1).toDouble(),
              divisions: RainIntensity.values.length - 1,
              label: initialIntensity.toString().split('.').last,
            );
          },
        ),
      ],
    );
  }
}

class TemperatureSlider extends StatelessWidget {
  final String title;
  final RangeValues initialRange;
  final ValueChanged<RangeValues> onChanged;

  TemperatureSlider({
    required this.title,
    required this.initialRange,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        StatefulBuilder(
          builder: (context, setState) {
            return RangeSlider(
              values: initialRange,
              min: -10,
              max: 45,
              divisions: 55,
              labels: RangeLabels(
                '${initialRange.start.round()}°C',
                '${initialRange.end.round()}°C',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  onChanged(values);
                });
              },
            );
          },
        ),
      ],
    );
  }
}

class WindSpeedSlider extends StatelessWidget {
  final String title;
  final RangeValues initialRange;
  final ValueChanged<RangeValues> onChanged;

  WindSpeedSlider({
    required this.title,
    required this.initialRange,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        StatefulBuilder(
          builder: (context, setState) {
            return RangeSlider(
              values: initialRange,
              min: 0,
              max: 100,
              divisions: 100,
              labels: RangeLabels(
                '${initialRange.start.round()} kph',
                '${initialRange.end.round()} kph',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  onChanged(values);
                });
              },
            );
          },
        ),
      ],
    );
  }
}
