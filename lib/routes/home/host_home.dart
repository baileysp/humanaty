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

class HostHome extends StatefulWidget {
  HostHome({Key key}) : super(key: key);
  @override
  _HostHomeState createState() => _HostHomeState();
}

class _HostHomeState extends State<HostHome> {
  DateTime _selectedDate;
  EventList<Event> _marked;
  List<HumanatyEvent> _selectedDateEvents;
  AuthService auth;

  @override
  void initState() {
    super.initState();
    _marked = EventList<Event>(events: {});
    _selectedDate = DateTime.now();
    _selectedDateEvents = [];
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);    

    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService(uid: auth.user.uid).myEvents,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          _createMarked(snapshot.data);
          _selectedDayEvents(snapshot.data);
        } 
        return Scaffold(
          body: Column(
            children: <Widget>[
              Container(height: SizeConfig.screenHeight * .6,
              child:_calendar()),
              _eventDisplay()
            ],
          )
        );
      });
  }

  Widget _eventDisplay() {
    var f = DateFormat.yMMMMd("en_US");
    return Expanded(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 8.0, top: 0.0, bottom: 0.0),
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
          _eventList()
        ],
      ),
    );
  }

  Widget _calendar() {
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
      child: CalendarCarousel(
        daysHaveCircularBorder: true,
        iconColor: Pallete.humanGreen,
        headerTextStyle: TextStyle(
            color: Colors.black, fontSize: 20.0, fontFamily: 'Nuninto_Sans'),
        onDayLongPressed: (DateTime time) {print('test');},
        onDayPressed: (DateTime date, List _) {
          this.setState(() => _selectedDate = date);
        },
        markedDatesMap: _marked,
        markedDateShowIcon: false,
        markedDateWidget:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(height: 4, width: 4, color: Pallete.humanGreen),
            ),
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

  Widget _eventList(){
    DateFormat f = DateFormat.jm();
    return Container(
      height: SizeConfig.screenHeight * .24,
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0.0),
        itemCount: _selectedDateEvents.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text('${_selectedDateEvents[index].title}'),
            trailing: Text('${f.format(_selectedDateEvents[index].date)}'),
            onTap: (){},
          );
        }),
    );
  }
  void _createMarked(List<HumanatyEvent> events){
    EventList<Event> _newMarked = EventList<Event>(events: {});
    for(int i = 0; i < events.length; i++){
      DateTime _date = events[i].date;
      _date = DateTime.parse(_date.toString().substring(0, _date.toString().indexOf(' ')));
      _newMarked.add(_date, Event(date: _date));
    }
    _marked = _newMarked;
  }

  void _selectedDayEvents(List<HumanatyEvent> events){
    List<HumanatyEvent> _newSelectedDateEvents = [];
    for(int i = 0; i < events.length; i++){
      if(_selectedDate.difference(events[i].date).inDays == 0){
        _newSelectedDateEvents.add(events[i]);
      }
      _selectedDateEvents = _newSelectedDateEvents;
      _selectedDateEvents.sort((event1, event2){
        return event1.date.compareTo(event2.date);
      });
    }
  }



}

class HostRouter extends StatefulWidget {
  @override
  HostRouterState createState() => HostRouterState();
}

class HostRouterState extends State<HostRouter> {
  int _navIndex;
  GlobalKey<ScaffoldState> _scaffoldKey;  
  final PageStorageBucket _bucket = PageStorageBucket();
  
  final List<Widget> pages = [
    Loading(),
    HostHome(key: PageStorageKey('HostHome')),
    MapPage(key: PageStorageKey('MapPage')),
    Loading() //key: PageStorageKey('MapPage'))
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
        body: PageStorage(child: pages[_navIndex], bucket: _bucket));
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _navIndex,
      onTap: selectNav,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Menu")),
        BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Farms")),
        BottomNavigationBarItem(
            icon: Icon(Icons.library_books), title: Text("My Events")),
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
