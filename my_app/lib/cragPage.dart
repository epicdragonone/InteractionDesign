import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_app/cragData.dart';
import 'weatherAPI.dart' as WAPI;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'cragData.dart';

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

class _MyHomePageState extends State<CragPage> {
  String weatherQuery = ""; // default for now

  List<FlSpot> tempHistory = [
    FlSpot(0, 1),
    FlSpot(1, 3),
    FlSpot(2, 10),
    FlSpot(3, 7),
    FlSpot(4, 12),
    FlSpot(5, 13),
    FlSpot(6, 17),
    FlSpot(7, 15),
    FlSpot(8, 20),
  ];
  List<FlSpot> rainHistory = [];
  List<FlSpot> windHistory = [];
  List<FlSpot> humidityHistory = [];

  HashMap<String, List<FlSpot>> history = new HashMap<String, List<FlSpot>>();

  String cragName = "";
  String cragDisplayName = "";

  _MyHomePageState(cragName) {
    setup(cragName);
  }

  @override
  void initState() {
    super.initState();
  }

  // tba: take cragname as an argument and then setup info for page
  void setup(cragName) {
    Map<String, dynamic> cragData = CragData().get()[cragName];

    cragDisplayName = cragData["name"];

    var now = DateTime.now().subtract(const Duration(days: 3));
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    // TODO: custom longitude and langitude
    weatherQuery = "q=52.2054,0.1132 dt=${formattedDate}";

    history.addAll({
      "tempHistory": tempHistory,
      "rainHistory": rainHistory,
      "windHistory": windHistory,
      "humidityHistory": humidityHistory
    });

    // for now: just make 5 queries for past 5 days
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.grey,
            height: 800,
            width: 360,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // title
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
                              flex: 3,
                              child: Container(
                                  child: Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(textAlign: TextAlign.left, "21°C"),
                                        Text(
                                            textAlign: TextAlign.left, "Rainy"),
                                        Text(textAlign: TextAlign.left, "Windy")
                                      ],
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                              textAlign: TextAlign.left,
                                              "Sunny"),
                                          Text(
                                              textAlign: TextAlign.left,
                                              "Sandstone"),
                                          Text(
                                              textAlign: TextAlign.left,
                                              "Intermediate")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )))
                        ],
                      ),
                    ),

                    // column with barcharts

                    Column(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: const Text(
                            "Rainfall History",
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          child: AspectRatio(
                            aspectRatio: 4,
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
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  leftTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ))));
  }
}
