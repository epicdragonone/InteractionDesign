import 'dart:ffi';

import 'package:flutter/material.dart';
import 'homePage.dart';
import 'filterPage.dart';
import 'searchMenu.dart';
import 'cragPage.dart';
import 'toggleButton.dart';
import 'weatherGetter.dart';
import 'cragData.dart';
import 'cragCurrentWeather.dart';

void main() {
  List<String> defaultCrags = ["crag_a", "crag_b", "crag_c", "crag_d", "crag_e", "crag_f", "crag_g", "crag_h", "crag_i", "crag_j", "crag_k", "crag_l", "crag_m", "crag_n", "crag_o"];
  String defaultHomePageCrag = "crag_a";
  runApp(MyApp(defaultCrags:defaultCrags, defaultHomePageCrag: defaultHomePageCrag,));

}

class MyApp extends StatefulWidget {
  final List<String> defaultCrags;
  final String defaultHomePageCrag;
  MyApp({Key? key,required this.defaultCrags, required this.defaultHomePageCrag}) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  bool isSideBarExpanded = false;
  bool isSearch = true;
  final double sideBarWidth = 0.8;
  String homePageCrag = '';

  Future<List<CragCurrentWeather>> initDefaultData(defaultCrags) async{
    List<CragCurrentWeather> cragWeatherList = [];
    for (String cragName in defaultCrags) {
      print(cragName);
      setState(()  {
        CragCurrentWeather cragWeather = CragCurrentWeather(cragName);
        cragWeather.initialize();
        cragWeatherList.add(cragWeather);
      });
    }
    return cragWeatherList;
  }

  Future<void> initializeData() async{
    print(widget.defaultCrags);
    defaultData = await initDefaultData(widget.defaultCrags);
    updateSearchMenuData(defaultData);
  }


  List<CragCurrentWeather> defaultData = []; //the intialisation should consider time

  List<CragCurrentWeather> searchMenuData = []; 

  @override
    void initState() {
    super.initState();
    initializeData(); 
    updateSearchMenuData(defaultData);
    updateHomePageCrag(widget.defaultHomePageCrag);
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

  void updateHomePageCrag(String newCragName){
    homePageCrag = newCragName;
    print(homePageCrag);
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
                HomePage(location:homePageCrag),

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
                      onCragSelected: (newCragName) => updateHomePageCrag(newCragName),
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
