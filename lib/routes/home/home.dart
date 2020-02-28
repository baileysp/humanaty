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
      eventName: "Test Title",
      eventDate: "1/11/23",
      eventDescription: "Description goes here"),
  HumanatyEvent(
    eventName: "Indian Food",
    eventDate: "1/14/23",
    eventDescription: "Come enjoy cuisine of the east.",
  ),
  HumanatyEvent(
      eventName: "Chinese Cuisine",
      eventDate: "1/11/23",
      eventDescription: "Get lost in the szechuan sauce."),
  HumanatyEvent(
      eventName: "Pizza Night at Johnny's",
      eventDate: "1/11/23",
      eventDescription: "Don't get lost in the tomato sauce."),
  HumanatyEvent(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually quite delicious",
  ),
  HumanatyEvent(
    eventName: "Not so Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "Don't buy a seat here",
  ),
  HumanatyEvent(
    eventName: "Test huMANAty Event",
    eventDate: "1/17/24",
    eventDescription: "Testing for home display purposes.",
  ),
  HumanatyEvent(
    eventName: "Test huMANAty Event",
    eventDate: "1/17/24",
    eventDescription: "Testing for home display purposes.",
  )
];

List<HumanatyEvent> displayedEvents = testEvents;

class HomePage extends StatefulWidget {
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //final _auth = Provider.of<AuthService>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //drawer: HumanatyDrawer(),
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

  Widget logout(AuthService _auth){
    Navigator.pop(context);
    _auth.signOut();
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
  int _navIndex = 0;
  ScrollController _scrollController = ScrollController();
  final _bottomNavBarKey = GlobalKey<ScaffoldState>();

  static const TextStyle navStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [Loading(), HomePage(), Map(), Map()];

  @override
  void initState() {
    _navIndex = 1;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomNavBarKey,
      drawer: HumanatyDrawer(),
      bottomNavigationBar: bottomNavBar(),
      body: _navigationOptions[_navIndex]
    );
  }

  Widget bottomNavBar(){
    return BottomNavigationBar(
        currentIndex: _navIndex,
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
    print(index);
    setState(() {
      index != 0 ? _navIndex = index : _bottomNavBarKey.currentState.openDrawer();    
    });
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }
}
