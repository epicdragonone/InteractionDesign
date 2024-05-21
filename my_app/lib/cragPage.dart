import 'dart:math';


import 'package:my_app/homePage.dart';
import 'package:my_app/main.dart';
import 'package:provider/provider.dart';

// import 'package:provider/provider.dart';
import 'dart:collection';
// import 'dart:io';
// import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:my_app/cragData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
// import 'cragData.dart';
import 'weatherGetter.dart' as api;

class CragPage extends StatefulWidget {
  const CragPage({super.key, required this.cragName, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String cragName;

  @override
  State<CragPage> createState() => _MyHomePageState(cragName);
}

/*
class PageMain extends StatelessWidget  {
  const PageMain({super.key, required this.cragName, required this.history});

  final HashMap<String, List<FlSpot>> history;
  final String cragName;

  @override
  Widget build(BuildContext context) {
    return 
  }
}
*/

class _MyHomePageState extends State<CragPage> with ChangeNotifier {
  String weatherQuery = ""; // default for now

  List<FlSpot> tempHistory = [];
  List<FlSpot> rainHistory = [];
  List<FlSpot> windHistory = [];
  List<FlSpot> humidityHistory = [];

  HashMap<String, List<FlSpot>> history = new HashMap<String, List<FlSpot>>();

  String cragName = "";
  String cragDisplayName = "";
  String location = "";
  String formattedDate = "";
  double temperature = 0;
  String condition = "";
  String cragRockType = "";
  String difficultyRange = "";

  Map<String, Map<String, num>> maxAndMin = {
    "temp": {
      "max": 0,
      "min": 999,
    },
    "rain": {"max": 0, "min": 999},
    "wind": {
      "max": 0,
      "min": 999,
    },
    "humidity": {
      "max": 0,
      "min": 999,
    }
  };

  List<api.Weather> currentWeather = [];

  _MyHomePageState(cragName) {
    setup(cragName);
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> getWeather(location, formattedDate) async {
    List<Future<api.Weather>> histories = [];

    for (var i = -12; i <= 0; i++) {
      int hours = DateTime.now().hour + i;
      DateTime now = DateTime.now();
      if (hours < 0) {
        hours = 24 + hours;
        now.subtract(const Duration(days: 1));
      }

      histories.add(api.WeatherApi()
          .fetchWeather(location, formattedDate, hours, "history"));
    }

    return await Future.wait(histories).then((historiesResolved) {
      double i = 0;

      api.Weather weatherRightNow = historiesResolved[11];
      condition = weatherRightNow.conditionText;
      temperature = weatherRightNow.tempC.toDouble();

      for (api.Weather w in historiesResolved) {
        maxAndMin["wind"]!["max"] = max(maxAndMin["wind"]!["max"]!, w.windKph);
        maxAndMin["wind"]!["min"] = min(maxAndMin["wind"]!["min"]!, w.windKph);

        maxAndMin["temp"]!["max"] = max(maxAndMin["temp"]!["max"]!, w.tempC);
        maxAndMin["temp"]!["min"] = min(maxAndMin["temp"]!["min"]!, w.tempC);

        maxAndMin["humidity"]!["max"] =
            max(maxAndMin["humidity"]!["max"]!, w.humidity);
        maxAndMin["humidity"]!["min"] =
            min(maxAndMin["humidity"]!["min"]!, w.humidity);

        maxAndMin["rain"]!["max"] =
            max(maxAndMin["rain"]!["max"]!, w.precip_mm);
        maxAndMin["rain"]!["min"] =
            min(maxAndMin["rain"]!["min"]!, w.precip_mm);

        tempHistory.add(FlSpot(i, w.tempC));
        rainHistory.add(FlSpot(i, w.precip_mm));
        windHistory.add(FlSpot(i, w.windKph));
        humidityHistory.add(FlSpot(i, w.humidity.toDouble()));
        i++;
      }
      history.addAll({
        "tempHistory": tempHistory,
        "rainHistory": rainHistory,
        "windHistory": windHistory,
        "humidityHistory": humidityHistory
      });
    });
  }

  // tba: take cragname as an argument and then setup info for page
  void setup(cragName) {
    print("test");
    Map<String, dynamic> cragInfo = CragData().get()[cragName];

    cragName = cragName;
    cragDisplayName = cragInfo["name"];
    cragRockType = cragInfo["rockMaterial"];
    difficultyRange =
        '${CragData().parseDifficulty(cragInfo["difficultyMin"])}-${CragData().parseDifficulty(cragInfo["difficultyMax"])}';

    location = cragInfo["location"];
    var now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);

    //getWeather(location, formattedDate);

    // for now: just make 5 queries for past 5 days
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          color: Colors.grey,
          height: 800,
          width: 360,
          child: FutureBuilder(
              future: getWeather(location, formattedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        // title
                        Align(
                            alignment: Alignment.topCenter,
                            child: ElevatedButton(
                                onPressed: () {
                                Map<String, String> c = {
                                  "Crag A": "crag_a",
                                  "Crag B": "crag_b",
                                  "Crag C": "crag_c",
                                  "Crag D": "crag_d",
                                  "Crag E": "crag_e",
                                  "Crag F": "crag_f",
                                  "Crag G": "crag_g",
                                  "Crag H": "crag_h",
                                  "Crag I": "crag_i",
                                  "Crag J": "crag_j",
                                  "Crag K": "crag_k",
                                  "Crag L": "crag_l",
                                  "Crag M": "crag_m",
                                  "Crag N": "crag_n",
                                  "Crag O": "crag_o",
                                };
                                                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp(defaultHomePageCrag: "stanage_edge",defaultCrags: ["stanage_edge", "froggatt_edge", "curbar_edge", "burbage_north", "burbage_south", "milstone_edge", "birchen_edge", "lawrencefield", "raven_tor", "dovedale", "chee_dale", "malham_cove", "goredale_scar", "kilnsey_crag", "beach_hill"],)),
                );
                                  //Navigator.pop(context);
                                  //super.dispose();
                                },
                                child: Text("back"))),
                        Center(
                          child: Text(
                            cragDisplayName,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ),

                        // row w/ picture and mainstats
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    child: Image.asset(
                                        'assets/images/rockPlaceholder.jpg'),
                                  )),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                            textAlign: TextAlign.left,
                                            '${temperature}°C'),
                                        Text(
                                            textAlign: TextAlign.left,
                                            condition)
                                      ],
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                              textAlign: TextAlign.left,
                                              cragRockType),
                                          Text(
                                              textAlign: TextAlign.left,
                                              difficultyRange)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                        // column with barcharts
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              const SizedBox(
                                width: double.infinity,
                                child: const Text(
                                  "Temperature History",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.black))),
                                child: AspectRatio(
                                  aspectRatio: 3.5,
                                  child: LineChart(
                                    LineChartData(
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                            spots: history["tempHistory"]!,
                                            dotData: FlDotData(show: false)),
                                      ],
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  String val =
                                                      '-${12 - value.toInt()}h';
                                                  if (val == "-0h") {
                                                    val = "now";
                                                  }
                                                  return Text(val);
                                                })),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 44,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  if (value ==
                                                          maxAndMin["temp"]![
                                                              "max"] &&
                                                      value !=
                                                          maxAndMin["temp"]![
                                                              "min"]) {
                                                    return Text("");
                                                  }
                                                  return Text(
                                                      '${value.toInt()}°C');
                                                })),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              const SizedBox(
                                width: double.infinity,
                                child: const Text(
                                  "Rainfall History",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.black))),
                                child: AspectRatio(
                                  aspectRatio: 3.5,
                                  child: LineChart(
                                    LineChartData(
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                            spots: history["rainHistory"]!,
                                            dotData: FlDotData(show: false)),
                                      ],
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  String val =
                                                      '-${12 - value.toInt()}h';
                                                  if (val == "-0h") {
                                                    val = "now";
                                                  }
                                                  return Text(val);
                                                })),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 44,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  if (value ==
                                                          maxAndMin["rain"]![
                                                              "max"] &&
                                                      value !=
                                                          maxAndMin["rain"]![
                                                              "min"]) {
                                                    return Text("");
                                                  }
                                                  return Text(
                                                      '${value.toInt()}mm');
                                                })),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              const SizedBox(
                                width: double.infinity,
                                child: const Text(
                                  "Wind Speed History",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.black))),
                                child: AspectRatio(
                                  aspectRatio: 3.5,
                                  child: LineChart(
                                    LineChartData(
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                            spots: history["windHistory"]!,
                                            dotData: FlDotData(show: false)),
                                      ],
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  String val =
                                                      '-${12 - value.toInt()}h';
                                                  if (val == "-0h") {
                                                    val = "now";
                                                  }
                                                  return Text(val);
                                                })),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 44,
                                                interval: 8,
                                                getTitlesWidget: (value, meta) {
                                                  if (value ==
                                                          maxAndMin["wind"]![
                                                              "max"] &&
                                                      value !=
                                                          maxAndMin["wind"]![
                                                              "min"]) {
                                                    return Text("");
                                                  }
                                                  return Text(
                                                      '${value.toInt()}kph');
                                                })),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              const SizedBox(
                                width: double.infinity,
                                child: const Text(
                                  "Humidity History",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    border: Border.symmetric(
                                        horizontal:
                                            BorderSide(color: Colors.black))),
                                child: AspectRatio(
                                  aspectRatio: 3.5,
                                  child: LineChart(
                                    LineChartData(
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                            spots: history["humidityHistory"]!,
                                            dotData: FlDotData(show: false)),
                                      ],
                                      titlesData: FlTitlesData(
                                        bottomTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                interval: 3,
                                                getTitlesWidget: (value, meta) {
                                                  String val =
                                                      '-${12 - value.toInt()}h';
                                                  if (val == "-0h") {
                                                    val = "now";
                                                  }
                                                  return Text(val);
                                                })),
                                        leftTitles: AxisTitles(
                                            sideTitles: SideTitles(
                                                showTitles: true,
                                                reservedSize: 44,
                                                interval: 8,
                                                getTitlesWidget: (value, meta) {
                                                  if (value ==
                                                          maxAndMin[
                                                                  "humidity"]![
                                                              "max"] ||
                                                      value ==
                                                          maxAndMin[
                                                                  "humidity"]![
                                                              "min"]) {
                                                    return Text("");
                                                  }
                                                  return Text(
                                                      '${value.toInt()}%');
                                                })),
                                        topTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(
                                            sideTitles:
                                                SideTitles(showTitles: false)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]));
                } else {
                  return CircularProgressIndicator();
                }
              })),
    ));
  }
}
