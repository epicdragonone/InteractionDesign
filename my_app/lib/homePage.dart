import 'package:flutter/material.dart';
import 'package:my_app/cragPage.dart';
import 'package:my_app/weatherGetter.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:my_app/cragData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'cragData.dart'; 
import 'weatherGetter.dart' as api;
import 'cragCurrentWeather.dart';

class HomePage extends StatefulWidget {
  // final String location;
  // final String weather;
  final String defaultCrag;
  const HomePage({super.key, required this.defaultCrag});
  
  @override
  _HomePageState createState() => _HomePageState();
}

// TODO: Change dates and times when pressing buttons. Make sure this works. Then, for each time, calculate the new weather inputs
// TODO: Make links with Cragnames dynamic etc. Do this by passing in the getWeather thing that WE have.


class _HomePageState extends State<HomePage> {

  String cragName = ""; // Done
  String difficulty = ""; // Done
  String imageAddress = ""; // Meh
  int rainedXHoursAgo = 0; // Done
  String heat = ""; // Done
  String wind = ""; // Done
  String rain = ""; // Done
  String calculatedGoodness = ""; // Done
  Color calculatedGoodnessColour = Color.fromARGB(0, 198, 147, 147); // Done
  int currTime = 11; 
  String alphaCrag = "crag_b"; 
  String betaCrag = "crag_c"; 
  String charlieCrag = "crag_d"; 
  String deltaCrag = "crag_e"; 
  String echoCrag = "crag_f";  
  String location = ""; // Done
  String formattedDate = ""; // Done
  double heatParam = 0; // Done
  double windParam = 0; // Done
  double rainParam = 0; // Done
  String trueCragName = "";


  void setup(String cragName) {
    print(cragName);
    Map<String, dynamic> cragInfo = CragData().get()[cragName];
    this.trueCragName = cragName;
    this.cragName = cragInfo["name"];
    difficulty = '${CragData().parseDifficulty(cragInfo["difficultyMin"])}-${CragData().parseDifficulty(cragInfo["difficultyMax"])}';
    location = cragInfo["location"];

    // getWeather(location, formattedDate);
  
  }


  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
    setup(widget.defaultCrag);
    print("homepage setup");
  }


  Future<void> getWeather(String location, String formattedDate) async {


    List<Future<api.Weather>> histories = [];

    for (var i = -12; i <= 0 ; i++) {
      int hours = DateTime.now().hour + i;
      DateTime now = DateTime.now();
      if (hours < 0) {
        hours = 24 + hours;
        now.subtract(const Duration(days: 1));
      }

      histories.add(api.WeatherApi().fetchWeather(location, formattedDate, hours, "history"));
      print("akakakakakak");
    }


    return await Future.wait(histories).then((historiesResolved) {
        
      // This is to find the last time it rained

      for (int i = 11; i >= 0; i--) {
        api.Weather weatherRightNow = historiesResolved[i];
        if (weatherRightNow.precip_mm > 0) {
          rainedXHoursAgo = i;
          break;
        }
      }


      //try {
        
        late Weather dataAtTime;

        // below line needs to be changed to get weather at the correct time
        dataAtTime = historiesResolved[11];

        /*
        if (currTime <= 11) { 
          dataAtTime = await api.WeatherApi().fetchWeather(location, formattedDate, currTime, "history");
          print("okokokok");
        } else {
          dataAtTime = await api.WeatherApi().fetchWeather(location, formattedDate, currTime, "forecast");
          print("monke");
        }
        */
        


        //setState(() {
          heat = '${dataAtTime.tempC}°C';
          wind = '${dataAtTime.windKph} kph';
          rain = '${dataAtTime.precip_mm} mm';
          rainedXHoursAgo = currTime;
          heatParam = dataAtTime.tempC;
          windParam = dataAtTime.windKph;
          rainParam = dataAtTime.precip_mm;
          if (heatParam <= 20 && heatParam >= 10 && windParam <= 25 && rainParam <= 0.2) {
            calculatedGoodness = 'Great';
            calculatedGoodnessColour = Color.fromARGB(255, 0, 255, 0);
          
          } else {
          
          if (heatParam >= 5 && heatParam <= 25 && windParam <= 40 && rainParam <= 4) {
            calculatedGoodness = 'OK';
            calculatedGoodnessColour = Color.fromARGB(255, 255, 187, 0);
          } else {
            calculatedGoodness = 'Bad';
            calculatedGoodnessColour = Color.fromARGB(255, 255, 0, 0);
          }
        }
        //});
      //} catch (e) {
      //  print('Error fetching weather data: $e');
     // }
      });
    
  }

  



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:getWeather(location, formattedDate),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done)
        {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Color.fromARGB(255, 255, 255, 255), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "$cragName - $location",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    difficulty,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // Colour behind the image
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CragPage(cragName: trueCragName,title: "title",)),
                );
              },
              child: const Image(
                image: NetworkImage("https://thumbs.dreamstime.com/b/summit-helm-crag-19175355.jpg"),
                height: 100,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.all(0),
            width: 230,
            height: 300,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // Colour of container
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
              border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    "Rained ${rainedXHoursAgo} hours ago",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 28,
                      color: Color(0xff000000),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        heat,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                      ),
                      Text(
                        wind,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                      ),
                      Text(
                        rain,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Text(
                    calculatedGoodness,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: calculatedGoodnessColour,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 25, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_left),
                            onPressed: () {currTime -= 3;},
                            color: Color(0xff212435),
                            iconSize: 24,
                          ),
                          Text(
                            "-3h",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_left),
                            onPressed: () {currTime -= 1;},
                            color: Color(0xff212435),
                            iconSize: 24,
                          ),
                          Text(
                            "-1h",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: Icon(Icons.restore),
                            onPressed: () {currTime = 11;},
                            color: Color(0xff212435),
                            iconSize: 24,
                          ),
                          Text(
                            currTime.toString(),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_right),
                            onPressed: () {currTime += 1;},
                            color: Color(0xff212435),
                            iconSize: 24,
                          ),
                          Text(
                            "+1h",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          IconButton(
                            icon: Icon(Icons.keyboard_double_arrow_right),
                            onPressed: () {currTime += 3;},
                            color: Color(0xff212435),
                            iconSize: 24,
                          ),
                          Text(
                            "+3h",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff000000),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 200,
              height: 100,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: const Color(0x4d9e9e9e), width: 1),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          setup("crag_b");
                          cragName = "crag_b";
                        },);
                      },
                      color: const Color(0xffffffff),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                      child: Text(
                        alphaCrag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          setup("crag_c");
                          cragName = "crag_c";
                        },);
                      },
                      color: const Color(0xffffffff),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                      child: Text(
                        betaCrag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                          setState(() {
                          setup("crag_d");
                          cragName = "crag_d";
                        },);
                      },
                      color: const Color(0xffffffff),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                      child: Text(
                        charlieCrag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          setup("crag_e");
                          cragName = "crag_e";
                        },);

                      },
                      color: const Color(0xffffffff),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                      child: Text(
                        deltaCrag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                          setState(() {
                          setup("crag_f");
                          cragName = "crag_f";
                        },);
                      },
                      color: const Color(0xffffffff),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                        side: BorderSide(color: Color(0xff808080), width: 1),
                      ),
                      padding: const EdgeInsets.all(16),
                      textColor: const Color(0xff000000),
                      height: 40,
                      minWidth: 140,
                      child:  Text(
                        echoCrag,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      );
  }
   else {
      return CircularProgressIndicator();
    }
  },
  
  );
  }
}