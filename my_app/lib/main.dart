import 'package:flutter/material.dart';
import 'homePage.dart';
import 'filterPage.dart';
import 'searchMenu.dart';
import 'cragPage.dart';
import 'toggleButton.dart';
import 'weatherGetter.dart';

void main() {
  final List<String> defaultLocationList = [
  'Istanbul', 'London', 'Dubai', 'Antalya', 'Paris', 'Hong Kong'];
  /*
  the default location list for search menu and home page, the home page will shown the first one
  */

  runApp(MyApp(defaultLocationList: defaultLocationList));
}

class MyApp extends StatefulWidget {
  final List<String> defaultLocationList;

  const MyApp({Key? key, required this.defaultLocationList}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSideBarExpanded = false;
  bool isSearch = true;
  final double sideBarWidth = 0.8;

  List<Weather> defaultWeatherData = []; //the intialisation should consider time
  List<Weather> searchMenuData = []; 

  @override
  void initState() {
    super.initState();
    fetchDefaultWeatherData(widget.defaultLocationList); 
    updateSearchMenuData(defaultWeatherData);
  }

  Future<void> fetchDefaultWeatherData(List<String> locations) async {
    final api = WeatherApi();
    for (String location in locations) {
      final weather = await api.fetchWeather(location);
      setState(() {
        defaultWeatherData.add(weather);
      });
    }
  }

  void toggleSideBar() {
    setState(() {
      isSideBarExpanded = !isSideBarExpanded;
    });
  }

  void toggleSearchFilter() {
    setState(() {
      isSearch = !isSearch;
    });
  }

  void updateSearchMenuData(List<Weather> weatherData) {
    setState(() {
      searchMenuData = weatherData;
    });
  }

  void handleFilterApply(List<Weather> filtered) {
    updateSearchMenuData(filtered);
    toggleSearchFilter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interaction Design Group 6',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double screenHeight = constraints.maxHeight;

          double desiredWidth = screenWidth;
          double desiredHeight = screenWidth * (9 / 16);

          return Container(
            width: desiredWidth,
            height: desiredHeight,
            child: Stack(
              children: [
                HomePage(location: widget.defaultLocationList[0]),

                // Display weather icons for default locations
                // for (int i = 0; i < defaultWeatherData.length; i++)
                //   Positioned(
                //     top: 20,
                //     left: 20 + (i * 100), // Adjust position as needed
                //     child: Column(
                //       children: [
                //         Image.network(
                //           defaultWeatherData[i].iconUrl,
                //           width: 64,
                //           height: 64,
                //         ),
                //         Text(
                //           'Weather: ${defaultWeatherData[i].tempC}°C, ${defaultWeatherData[i].conditionText}',
                //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ),

                if (isSideBarExpanded && isSearch)
                  Positioned(
                    child: SearchMenu(
                      width: screenWidth * sideBarWidth,
                      data: searchMenuData, // Pass weather data instead of strings
                      onFilterButtonPressed: toggleSearchFilter,
                    ),
                  ),

                if (isSideBarExpanded && !isSearch)
                  Positioned(
                    child: FilterPage(
                      width: screenWidth * sideBarWidth,
                      onApplyButtonPressed: handleFilterApply,
                    ),
                  ),
                Positioned(
                  left: screenWidth * (isSideBarExpanded ? sideBarWidth : 0) - 10,
                  top: screenHeight * 0.5,
                  child: ToggleButton(
                    selected: isSideBarExpanded,
                    onPressed: toggleSideBar,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
