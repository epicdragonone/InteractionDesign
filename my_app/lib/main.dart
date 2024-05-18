import 'package:flutter/material.dart';
import 'homePage.dart';
import 'filterPage.dart';
import 'searchMenu.dart';
import 'cragPage.dart';
import 'toggleButton.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSideBarExpanded = false;
  bool isSearch = true; //true for search, false for filter
  final double sideBarWidth = 0.8;

  List<String> searchMenuData = [
      'Crag01',
      'Crag02',
      'Crag03',
      'Crag04',
      'Crag05',
      'Crag06',
      'Crag07',
      'Crag08',
      'Crag09',
      'Crag10',
      'Crag11',
      'Crag12',
      'Crag13',
      'Crag14',
      'Crag15',
    ];

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

  //filter page update search menu's data
  void updateSearchMenuData(List<String> newData) {
    setState(() {
      searchMenuData = newData;
    });
  }

  void handleFilterApply(List<String> filtered) {
    updateSearchMenuData(filtered);
    toggleSearchFilter();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interaction Design Group 6',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
            home:LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double screenHeight = constraints.maxHeight;

            // Calculate the desired width and height for a 16:9 aspect ratio
            double desiredWidth = screenWidth;
            double desiredHeight = screenWidth * (9 / 16);
            
            // Use AspectRatio widget to enforce the 16:9 aspect ratio
          return Container(
            width: desiredWidth,
            height: desiredHeight,
            child: 
              Stack(
                children:[
                  const HomePage(), 

          if (isSideBarExpanded && isSearch) //expand search menu
                    Positioned(
                      child: SearchMenu(
                        width: screenWidth * sideBarWidth,
                        data: searchMenuData,
                        onFilterButtonPressed: toggleSearchFilter,
                      ),
                    ),

          if (isSideBarExpanded && !isSearch) //expand filter page
                    Positioned(
                        child: FilterPage(
                          width: screenWidth * sideBarWidth,
                          onApplyButtonPressed: handleFilterApply
                        ),
                    ),

            
          Positioned(
                    left: screenWidth * (isSideBarExpanded ? sideBarWidth : 0) - 10, // Adjust positioning
                    top: screenHeight * 0.5, // Adjust positioning
                    child: ToggleButton(
                      
                      selected: isSideBarExpanded,
                      onPressed: toggleSideBar,
                    ),
                  ),
              ]
              )
              );
              }
              )
        );
  }
}


