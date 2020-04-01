import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HostHomePage extends StatefulWidget {
  HostHomePageState createState() => HostHomePageState();
}

class HostHomePageState extends State<HostHomePage> {
  DateTime _selectedDate;
  EventList<Event> _marked;

  @override
  void initState() {
    super.initState();
    _marked = EventList<Event>(events: {});
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final _auth = Provider.of<AuthService>(context);
    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService(uid: _auth.user.uid).myEvents,
      builder: (context, snapshot) {
        print(snapshot.hasData);
        //if(snapshot.hasData) createMarked(snapshot.data);
        return Scaffold(
          body: Column(
            children: <Widget>[
              Container(height: SizeConfig.screenHeight * .6,
              child: _calendar(context)),
              _eventDisplay(context)
            ],
          )
        );
      });
  }

  Widget _eventDisplay(BuildContext context) {
    var f = DateFormat.yMMMMd("en_US");
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Align(
                  child: Text(
                    'Events on ' + f.format(_selectedDate),
                    style: TextStyle(fontSize: 18.0),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  color: Colors.black54,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateEvent(eventDate: _selectedDate))),
                )
              ],
            ),
          ),
          Text('Event Card 1'),
          SizedBox(
            height: 16.0,
          ),
          Text('Event Card 2')
        ],
      ),
    );
  }

  Widget _calendar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: CalendarCarousel(
        daysHaveCircularBorder: true,
        iconColor: Pallete.humanGreen,
        headerTextStyle: TextStyle(
            color: Colors.black, fontSize: 20.0, fontFamily: 'Nuninto_Sans'),
        onDayLongPressed: (DateTime time) {},
        onDayPressed: (DateTime date, List _) {
          //if(_marked.removeAll(date).isEmpty) _marked.add(date, Event(date: date));
          this.setState(() {
            _selectedDate = date;
          });
        },
        markedDatesMap: _marked,
        markedDateShowIcon: false,
        markedDateWidget:
            Container(height: 4, width: 4, color: Pallete.humanGreen),
        selectedDateTime: _selectedDate,
        selectedDayBorderColor: Colors.transparent,
        selectedDayButtonColor: Pallete.humanGreen54,
        todayButtonColor: Colors.transparent, //.humanGreen54,
        todayBorderColor: Colors.transparent, //.humanGreen54,
        todayTextStyle: TextStyle(color: Colors.black),
        weekdayTextStyle:
            TextStyle(color: Colors.black, fontFamily: 'Nuninto_Sans'),
        weekendTextStyle:
            TextStyle(color: Colors.black, fontFamily: 'Nuninto_Sans'),
      ),
    );
  }

  void createMarked(List<HumanatyEvent> events){
    EventList<Event> _newMarked = EventList<Event>(events: {});
    for(int i = 0; i < events.length; i++){
      DateTime _date = events[i].date;
      _newMarked.add(_date, Event(date: _date));
    }
    setState(() => _marked = _newMarked);
    print(_marked);
  }

}

class HostRouter extends StatefulWidget {
  @override
  HostRouterState createState() => HostRouterState();
}

class HostRouterState extends State<HostRouter> {
  int _navIndex = 0;
  ScrollController _scrollController = ScrollController();
  final _bottomNavBarKey = GlobalKey<ScaffoldState>();

  static const TextStyle navStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final _navigationOptions = [
    Loading(),
    HostHomePage(),
    HostHomePage(),
    HostHomePage()
  ];

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
        body: _navigationOptions[_navIndex]);
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: selectNav,
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Menu")),
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_books), title: Text("My Events")),
      ],
      selectedItemColor: Pallete.humanGreen,
    );
  }

  void selectNav(int index) {
    print(index);
    setState(() {
      index != 0
          ? _navIndex = index
          : _bottomNavBarKey.currentState.openDrawer();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
