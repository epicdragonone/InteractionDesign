import 'package:flutter/material.dart';
import 'homePage.dart';
import 'filterPage.dart';
import 'searchMenu.dart';
// import 'cragPage.dart';
import 'toggleButton.dart';
// import 'weatherGetter.dart';
// import 'cragData.dart';
import 'cragCurrentWeather.dart';

void main() {
  List<String> defaultCrags = ["Crag A","Crag B","Crag C","Crag D","Crag E","Crag F","Crag G","Crag H","Crag I","Crag J","Crag K","Crag L","Crag M","Crag N","Crag O"];
  runApp(MyApp(defaultCrags:defaultCrags));

}

class MyApp extends StatefulWidget {
  final List<String> defaultCrags = [];
  MyApp({Key? key,required defaultCrags}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSideBarExpanded = false;
  bool isSearch = true;
  final double sideBarWidth = 0.8;


  void initDefaultData(defaultCrags) async{
    for (String cragName in defaultCrags) {
      setState(() {
        defaultData.add(CragCurrentWeather(cragName));  
      });
    }
  }

  List<CragCurrentWeather> defaultData = []; //the intialisation should consider time

  List<CragCurrentWeather> searchMenuData = []; 

  @override
  void initState() {
    super.initState();
    initDefaultData(widget.defaultCrags); 
    updateSearchMenuData(defaultData);
  }

  Future<void> fetchDefaultWeatherData(List<String> locations) async {
    
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

  void updateSearchMenuData(List<CragCurrentWeather> newData) {
    setState(() {
      searchMenuData = newData;
    });
  }

  void handleFilterApply(List<CragCurrentWeather> filtered) {
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
                HomePage(location:"Cambridge"),

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
                      data: defaultData,
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
