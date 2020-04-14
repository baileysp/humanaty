import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';

/**
 * Current TODOs:
 * 1. Reuseable event card widget
 * 2. Reuseable list of events widget
 * 3. SearchBar functionality – what kind of key terms do users enter, what are results
 * 4. Event details page
 */

//Screen/Widget that is displayed for the Home page is the 'Current' class

List<HumanatyEvent2> testEvents = [
  HumanatyEvent2(
      eventName: "Test Title",
      eventDate: "1/11/23",
      eventDescription: "Description goes here"),
  HumanatyEvent2(
    eventName: "Indian Food",
    eventDate: "1/14/23",
    eventDescription: "Come enjoy cuisine of the east.",
  ),
  HumanatyEvent2(
      eventName: "Chinese Cuisine",
      eventDate: "1/11/23",
      eventDescription: "Get lost in the szechuan sauce."),
  HumanatyEvent2(
      eventName: "Pizza Night at Johnny's",
      eventDate: "1/11/23",
      eventDescription: "Don't get lost in the tomato sauce."),
  HumanatyEvent2(
    eventName: "Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "It's actually quite delicious",
  ),
  HumanatyEvent2(
    eventName: "Not so Delicious Dinner",
    eventDate: "1/17/24",
    eventDescription: "Don't buy a seat here",
  ),
  HumanatyEvent2(
    eventName: "Test huMANAty Event",
    eventDate: "1/17/24",
    eventDescription: "Testing for home display purposes.",
  ),
  HumanatyEvent2(
    eventName: "Test huMANAty Event",
    eventDate: "1/17/24",
    eventDescription: "Testing for home display purposes.",
  )
];

List<HumanatyEvent2> displayedEvents = testEvents;

class GuestHome extends StatefulWidget {
  GuestHome({Key key}) : super(key: key);
  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  @override
  Widget build(BuildContext context) {
    //final _auth = Provider.of<AuthService>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            _title(),
            searchBar(),
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

  Widget _title(){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "HuMANAty",
          style: TextStyle(fontSize: 34),
        ),
      ));}

  Widget searchBar() {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(8, 20, 8, 10),
        child: FlatButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Search for huMANAty events...",
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.search)
              ],
            ),
            onPressed: () async {
              String location = await showSearch(context: context, delegate: MapSearch());
              if(location != null){
                Navigator.of(context).pushNamed('/map_events', arguments: {'displayBackBtn': true});          
              }               
            }));
  }
}

class GuestRouter extends StatefulWidget {
  @override
  GuestRouterState createState() => GuestRouterState();
}

class GuestRouterState extends State<GuestRouter>{
  int _navIndex;
  GlobalKey<ScaffoldState> _scaffoldKey;  
  final PageStorageBucket _bucket = PageStorageBucket();
  
  final List<Widget> _pages = [
    Loading(),
    GuestHome(key: PageStorageKey('GuestHome')),
    MapEvents(key: PageStorageKey('MapEvents')),
    Loading()
  ];
  
  @override
  void initState() {
    _navIndex = 1;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: HumanatyDrawer(),
        bottomNavigationBar: bottomNavBar(),
        body: PageStorage(child: _pages[_navIndex], bucket: _bucket));
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: selectNav,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Menu")),
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
        BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("TBD")),
      ],
      selectedItemColor: Pallete.humanGreen,
    );
  }        

  void selectNav(int index) {
    setState(() {
      index != 0
          ? _navIndex = index
          : _scaffoldKey.currentState.openDrawer();
    });
  }
}
