import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';

//Screen/Widget that is displayed for the Home page is the 'Current' class
class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HumanatyDrawer(),
      body: Stack(
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: NetworkImage('https://images.unsplash.com/photo-1517030330234-94c4fb948ebc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80'),
          //       fit: BoxFit.cover
          //     )
          //   ),
          // )
          Padding(
            padding: EdgeInsets.all(60),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Humanaty",
                style: TextStyle(fontSize: 30),
              ),
            )
          )
        ],
      )
    );
  }
}

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int navIndex = 0;
  static const TextStyle navStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [
    Current(),
    Settings(),
    Settings(),
    Map(),
    Map()
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
