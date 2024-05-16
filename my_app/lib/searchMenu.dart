import 'package:flutter/material.dart';
import 'package:my_app/toggleButton.dart';
import 'weatherAPI.dart';
import "toggleButton.dart";

// class SearchMenu extends StatelessWidget {
//   const SearchMenu({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const ResultsList();
//   }
// }

// class ExpandableSearchMenu extends StatefulWidget {
//   @override
//   _ExpandableSearchMenuState createState() => _ExpandableSearchMenuState();
// }

// class _ExpandableSearchMenuState extends State<ExpandableSearchMenu> {
//   bool _isMenuExpanded = false;

//   void _toggleMenu() {
//     setState(() {
//       _isMenuExpanded = !_isMenuExpanded;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//     AnimatedContainer(
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       width: _isMenuExpanded ? MediaQuery.of(context).size.width : 0,
//       child: 
//         Scaffold(
//         appBar: AppBar(
//           title: Text('Expandable Search Menu'),
//           leading: _isMenuExpanded
//               ? IconButton(
//                   icon: Icon(Icons.arrow_back),
//                   onPressed: _toggleMenu,
//                 )
//               : null,
//         ),
//         body: Stack(
//           children: [
//             // Main content of the screen
//             Center(
//               child: Text(
//                 'Main Content',
//                 style: TextStyle(fontSize: 24.0),
//               ),
//             ),
//             // Animated search menu
//             AnimatedContainer(
//               duration: Duration(milliseconds: 300),
//               curve: Curves.easeInOut,
//               width: _isMenuExpanded ? MediaQuery.of(context).size.width * 0.6 : 0,
//               height: MediaQuery.of(context).size.height,
//               color: Colors.white,
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Search Menu',
//                       style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 20.0),
//                     TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Enter your search query...',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: _isMenuExpanded
//             ? null // Hide FloatingActionButton when menu is expanded
//             : FloatingActionButton(
//                 onPressed: _toggleMenu,
//                 tooltip: 'Expand Search',
//                 child: Icon(Icons.search),
//               ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//       ),
//     );
//   }
// }




class SearchMenu extends StatefulWidget {

  final double width; // Width parameter
  const SearchMenu({Key? key, required this.width}) : super(key: key);

  @override
  State<SearchMenu> createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {

  bool _isExpanded = false;

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  final TextEditingController _searchController = TextEditingController();

  final List<String> _data = [
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
  List<String> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredData = _data;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
  
    //Simulates waiting for an API call
    await Future.delayed(const Duration(milliseconds: 1000));

    setState(() {
      _filteredData = _data
          .where((element) => element
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width, // Set the width from the parameter
      child: 
    Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView.builder(
                itemCount: _filteredData.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    _filteredData[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
        backgroundColor: Colors.deepPurple.shade900,
      ));
  }
}




// class ResultsList extends StatelessWidget {
//   const ResultsList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(8),
//       children: <Widget>[
//         Container(
//           height: 50,
//           color: Colors.amber[600],
//           child: const Center(child: Text('Entry A')),
//         ),
//         Container(
//           height: 50,
//           color: Colors.amber[500],
//           child: const Center(child: Text('Entry B')),
//         ),
//         Container(
//           height: 50,
//           color: Colors.amber[400],
//           child: const Center(child: Text('Entry C')),
//         ),
//         Container(
//           height: 50,
//           color: Colors.amber[300],
//           child: const Center(child: Text('Entry C')),
//         ),
//         Container(
//           height: 50,
//           color: Colors.amber[200],
//           child: const Center(child: Text('Entry C')),
//         ),
//         Container(
//           height: 50,
//           color: Colors.amber[100],
//           child: const Center(child: Text('Entry C')),
//         ),
//       ],
//       );
//   }
// }


// class ToggleButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//           onPressed: () {
//           },
//           child: Text('toggle'),
//         )
//   }
// }
