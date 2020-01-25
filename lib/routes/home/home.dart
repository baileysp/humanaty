import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:loader_search_bar/loader_search_bar.dart';
/**
 * Current TODOs:
 * 1. Reuseable event card widget
 * 2. Reuseable list of events widget
 * 3. SearchBar functionality – what kind of key terms do users enter, what are results
 * 4. Event details page
 */

//Screen/Widget that is displayed for the Home page is the 'Current' class

List<HumanatyEvent> testEvents = [
  HumanatyEvent(eventName: "Test", eventDate: "1/11/23", eventDescription: "Blah Blah Blah Blah ", cardClicked:() {
    print("Clicked");
  }),
  HumanatyEvent(eventName: "DINNER TIME", eventDate: "1/14/23", eventDescription: "scrumptuous dinner with corona virus",),
  HumanatyEvent(eventName: "Delicious Dinner", eventDate: "1/17/24", eventDescription: "It's actually not delicious",),
];

  var test = HumanatyEvent(eventName: "Test", eventDate: "1/11/23", eventDescription: "Blah Blah Blah Blah ",);
class Current extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HumanatyDrawer(),
      body: Column(
        children: <Widget>[
          mainSearch,
          title,
          HumanatyEventList(events: testEvents),
        ],
      )
    );
  }
}

Widget title = Container(
  padding: const EdgeInsets.fromLTRB(0, 30, 0, 22),
  child: Align(
    alignment: Alignment.topCenter,
    child: Text(
      "Humanaty",
      style: TextStyle(fontSize: 34),
    ),
  )
);

//TODO: Build searchbar widget, no existing searchbar
Widget searchBar = Container(
  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
  child: Text(
    "[Searchbar goes here]",
    style: TextStyle(fontSize: 16)
  )
);

//Temp Use
Widget mainSearch = SearchBar(
  
  defaultBar: AppBar(
    title: Text("Organic meals near you!"),
  ),
);

//Display upcoming events user is registered for
Widget events = Column(
  children: <Widget>[

  ],
);

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
