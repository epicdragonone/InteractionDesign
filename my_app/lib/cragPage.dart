import 'package:flutter/material.dart';


class CragPage extends StatefulWidget {
  const CragPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<CragPage> createState() => _MyHomePageState();
}

class PageMain extends StatelessWidget  {
  const PageMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // title
        const Center(
          child: Text(
            "Cragname",
            textAlign: TextAlign.center,
          ),
        ),


        // row w/ picture and mainstats
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset('assets/images/rockPlaceholder.jpg'),
              )
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Expanded(
                  flex: 2,
                  child: Row(children: [
                    Column(children: [
                      Text(
                        textAlign: TextAlign.left,
                        "21°C"),
                      Text(
                        textAlign: TextAlign.left,
                        "Rainy"),
                      Text(
                        textAlign: TextAlign.left,
                        "Windy")
                    ],),
                    Expanded(
                      flex: 2,
                      child: Column(children: [
                        Text(
                          textAlign: TextAlign.left,
                          "Sunny"),
                        Text(
                          textAlign: TextAlign.left,
                          "Sandstone"),
                        Text(
                          textAlign: TextAlign.left,
                          "Intermediate")
                      ],),
                    )
                  ],),
                )
              )
            )
          ],),
        ),

        // column with barcharts
        Column()
      ],
    );
  }
}

class _MyHomePageState extends State<CragPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.grey,
        height:800,
        width: 360,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PageMain(),
        )
      )
    );
  }
}
