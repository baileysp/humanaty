import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:loader_search_bar/loader_search_bar.dart';
import 'package:provider/provider.dart';
/**
 * Current TODOs:
 * 1. Reuseable event card widget
 * 2. Reuseable list of events widget
 * 3. SearchBar functionality – what kind of key terms do users enter, what are results
 * 4. Event details page
 */

//Screen/Widget that is displayed for the Home page is the 'Current' class

List<HumanatyEvent> testEvents = [
  HumanatyEvent(
      eventName: "Test",
      eventDate: "1/11/23",
      eventDescription: "Blah Blah Blah Blah "),
  HumanatyEvent(
    eventName: "DINNER TIME",
    eventDate: "1/14/23",
    eventDescription: "scrumptuous dinner with corona virus",
  ),
  HumanatyEvent(
      eventName: "Test",
      eventDate: "1/11/23",
      eventDescription: "Blah Blah Blah Blah "),
  HumanatyEvent(
      eventName: "Test",
      eventDate: "1/11/23",
      eventDescription: "Blah Blah Blah Blah "),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually not delicious",
  ),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually not delicious",
  ),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually not delicious",
  ),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually not delicious",
  ),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually not delicious",
  ),
];

List<HumanatyEvent> displayedEvents = testEvents;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: HumanatyDrawer(),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            // mainSearch,
            title,
            searchBar,
            // HumanatyEventList(events: testEvents),
            ListView.builder(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: testEvents.length,
              controller: ScrollController(),
              itemBuilder: (context, index) {
                return testEvents[index];
              },
            )
          ],
        )));
  }

  Widget title = Container(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "HuMANAty",
          style: TextStyle(fontSize: 34),
        ),
      ));

  //TODO: Build searchbar widget, no existing searchbar
  Widget searchBar = Container(
      padding: const EdgeInsets.fromLTRB(36, 20, 36, 10),
      child: TextField(
        decoration: InputDecoration(hintText: "City name here..."),
        onChanged: (text) {
          text = text.toLowerCase();
          // setState(() {
          //   displayedEvents = testEvents.where((event) {
          //     var title = event.eventName.toLowerCase();
          //     return title.contains(title);
          //   }).toList();
          // });
        },
      ));
}

class BottomNavBarRouter extends StatefulWidget {
  @override
  BottomNavBarRouterState createState() => BottomNavBarRouterState();
}

class BottomNavBarRouterState extends State<BottomNavBarRouter> {
  int navIndex = 0;
  ScrollController scrollController = new ScrollController();

  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }
  
  static const TextStyle navStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [HomePage(), HomePage(), Map(), Map()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavBar(),
      body: _navigationOptions[navIndex],
    );
  }

  Widget bottomNavBar(){
    return BottomNavigationBar(
        currentIndex: navIndex,
        onTap: selectNav,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Menu")),
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("My Events")),
        ],
        selectedItemColor: Pallete.humanGreen,
      );
  }
  void selectNav(int index) {
    setState(() {
      navIndex = index;
    });
  }
}
