import 'package:flutter/material.dart';
import 'package:my_app/weatherGetter.dart';
enum RainIntensity { dry, drizzle, heavy, storm }

class FilterPage extends StatelessWidget {
  final Function(List<Weather>) onApplyButtonPressed;
  final double width;
  const FilterPage({Key? key,required this.width, required this.onApplyButtonPressed}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        child:
      Scaffold(
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
          children:[
            RainIntensitySlider(title: 'Rainfall Intensity'),
            RainChanceSlider(title: 'Rainfall Chance'),
            TemperatureSlider(title: 'Temperature (deg C)'),
            WindSpeedSlider(title: 'Windspeed (mph)'),
            ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(5),
                ),
                onPressed: () {
                  // Build filter criteria based on current slider values
                  // Pass filter criteria back to the parent widget
                  //For now just pass an empty one
                  final List<Weather> filtered = []; 
                  
                  onApplyButtonPressed(filtered);
                },
                child: Text('Apply'), // Add this child parameter
              )
            ]
            ),
        ));
  }
}

class RainIntensitySlider extends StatefulWidget {
  final String title;

  const RainIntensitySlider({required this.title, Key? key}) : super(key: key);

  @override
  State<RainIntensitySlider> createState() => _RainIntensitySliderState();
}

class _RainIntensitySliderState extends State<RainIntensitySlider> {
  RainIntensity _currentIntensity = RainIntensity.dry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        Slider(
          value: _currentIntensity.index.toDouble(),
          onChanged: (double value) {
            setState(() {
              _currentIntensity = RainIntensity.values[value.toInt()];
            });
          },
          min: 0,
          max: (RainIntensity.values.length - 1).toDouble(),
          divisions: RainIntensity.values.length - 1,
          label: _currentIntensity.toString().split('.').last,
        ),
      ],
    );
  }
}

class RainChanceSlider extends StatefulWidget {
  final String title;

  const RainChanceSlider({required this.title, Key? key}) : super(key: key);

  @override
  State<RainChanceSlider> createState() => _RainChanceSliderState();
}

class _RainChanceSliderState extends State<RainChanceSlider> {
  RangeValues _currentRainChanceRange = const RangeValues(0, 100);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        RangeSlider(
          values: _currentRainChanceRange,
          min: 0,
          max: 100,
          divisions: 100,
          labels: RangeLabels(
            _currentRainChanceRange.start.round().toString() + '%',
            _currentRainChanceRange.end.round().toString() + '%',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRainChanceRange = values;
            });
          },
        ),
      ],
    );
  }
}

class TemperatureSlider extends StatefulWidget {
  final String title;

  const TemperatureSlider({required this.title, Key? key}) : super(key: key);

  @override
  State<TemperatureSlider> createState() => _TemperatureSliderState();
}

class _TemperatureSliderState extends State<TemperatureSlider> {
  RangeValues _currentTemperatureRange = const RangeValues(-10, 45);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        RangeSlider(
          values: _currentTemperatureRange,
          min: -10,
          max: 45,
          divisions: 55,
          labels: RangeLabels(
            _currentTemperatureRange.start.round().toString() + '°C',
            _currentTemperatureRange.end.round().toString() + '°C',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentTemperatureRange = values;
            });
          },
        ),
      ],
    );
  }
}

class WindSpeedSlider extends StatefulWidget {
  final String title;

  const WindSpeedSlider({required this.title, Key? key}) : super(key: key);

  @override
  State<WindSpeedSlider> createState() => _WindSpeedSliderState();
}

class _WindSpeedSliderState extends State<WindSpeedSlider> {
  RangeValues _currentWindSpeedRange = const RangeValues(0, 70);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title),
        RangeSlider(
          values: _currentWindSpeedRange,
          min: 0,
          max: 70,
          divisions: 70,
          labels: RangeLabels(
            _currentWindSpeedRange.start.round().toString() + ' mph',
            _currentWindSpeedRange.end.round().toString() + ' mph',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentWindSpeedRange = values;
            });
          },
        ),
      ],
    );
  }
}

