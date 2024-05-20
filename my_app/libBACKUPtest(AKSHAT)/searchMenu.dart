import 'package:flutter/material.dart';
import 'package:my_app/weatherGetter.dart';

class SearchMenu extends StatefulWidget {

  final double width; // Width parameter
  final List<Weather> data;
  final VoidCallback onFilterButtonPressed;

  const SearchMenu({Key? key, required this.width, required this.data, required this.onFilterButtonPressed}) : super(key: key);

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
  
  List<Weather> _filteredData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _filteredData = widget.data;
    print(_filteredData);
    print("donw!!!");
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
      _filteredData = widget.data
          .where((element) => element.locationName //display name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      _isLoading = false;
      print(_isLoading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width, 
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
          title: Row(
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0), // Adjust as needed
                  child: TextField(
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
              ),
              Expanded(
                flex: 2,
                child: IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {widget.onFilterButtonPressed();},
                ),
              ),
            ],
          ),
        ),
    body: _isLoading
    ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
    : LayoutBuilder(
        builder: (context, constraints) {
          final listViewWidth = constraints.maxWidth;

          return ListView.builder(
            itemCount: _filteredData.length,
            itemBuilder: (context, index) => ListTile(
              title: FractionallySizedBox(
                widthFactor: 1.0, //row takes the full width
                child: Row(
                  children: [
                    Expanded(
                      flex: 1, 
                      child: Align(
                        alignment: Alignment.centerLeft, //Align text to the left vertically!!
                        child: Padding(
                          padding: EdgeInsets.only(left: listViewWidth*0.02), //Padding relative to the ListView width
                          child: Text(
                            _filteredData[index].locationName, // Display name
                            style: const TextStyle(color: Colors.white, fontSize:18,fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: listViewWidth*0.4), //Padding relative to the ListView width
                          child: Image.network(
                            _filteredData[index].iconUrl,
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

        backgroundColor: Colors.deepPurple.shade900,
      ));
  }
}


