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
  bool isSearchMenuExpanded = false;

  void toggleSearchMenu() {
    setState(() {
      isSearchMenuExpanded = !isSearchMenuExpanded;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Stack(children: [
                HomePage(), 
                Positioned(
                  child: SearchMenu(
                    width: MediaQuery.of(context).size.width *
                  (isSearchMenuExpanded ? 0.413 : 0), //wierd offset to align SearchMenu and ToggleButton
                  ),
                ),
                Positioned(
                left: MediaQuery.of(context).size.width *
                  (isSearchMenuExpanded ? 0.4 : -0.013),
                top:MediaQuery.of(context).size.height * 0.5,
                child: ToggleButton(
                  onPressed: toggleSearchMenu,
                ),
                
                ),
            ])
    );
  }
}

