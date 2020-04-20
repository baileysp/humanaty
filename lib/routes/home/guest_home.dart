import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/humanaty_event.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:provider/provider.dart';

class GuestHome extends StatefulWidget {
  GuestHome({Key key}) : super(key: key);
  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> {
  AuthService auth;
  DatabaseService database;
  
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);
    SizeConfig().init(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
      children: <Widget>[
        _title(),
        searchBar(),
        StreamBuilder<List<HumanatyEvent>>(
          stream: database.getEvents(),
          builder:(context, snapshot){
            if(snapshot.hasData){
              List<HumanatyEvent> events = snapshot.data;
              return _eventListTiles(events);
            }
            return Container(
              height: SizeConfig.screenHeight * .6, 
              child: Loading());
          })
      ],
      ));
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

  Widget _eventListTiles(List<HumanatyEvent> events){
    return Container(
      height: SizeConfig.screenHeight * .6,
      child:
        ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index){
            return HumanatyCard(
              event: events[index]
            );
          }),
      );
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
