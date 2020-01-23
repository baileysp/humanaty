import 'package:flutter/material.dart';
/*
  TODO: Set up body parameter so it switches to correct page (navigation/routing)
 */
class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int navIndex = 0;
  static const TextStyle navStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [
    Text("Home", style: navStyle,),
    Text("Settings", style: navStyle,),
    Text("Map", style: navStyle,),
    Text("Map2", style: navStyle,),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: selectNav,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings")
          ),
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map")
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("Map")
        ),
      ],
      selectedItemColor: Colors.amber[800],
      ),
      body: _navigationOptions[navIndex],

    );
  }
  void selectNav(int index) {
    setState(() {
      navIndex = index;
    });
  }
}
