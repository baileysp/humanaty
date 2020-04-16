import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/logger.dart';

class HostEventInfo extends StatefulWidget{
  final String eventID;
  HostEventInfo({this.eventID});
  @override
  _HostEventInfo createState() => _HostEventInfo();
}

class _HostEventInfo extends State<HostEventInfo>{
  AuthService auth;
  DatabaseService database;
  Logger log;
  
  @override
  void initState() {
    log = getLogger('HostEventInfo');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);
    SizeConfig().init(context);

    return StreamBuilder<HumanatyEvent>(
      stream: database.getEvent(widget.eventID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          HumanatyEvent event = snapshot.data;
          return _build(event);
        } else {
          return Scaffold(
            appBar: HumanatyAppBar(displayBackBtn: true),
            body: Loading());
        }
      }
    );
  }

  Widget _build(HumanatyEvent event){
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: 'Event Info'),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: <Widget>[
          _title(event.title),
          Divider(),
          _location(event.location),
          Divider(),
          _date(event.date),
          Divider(),
          _menu(event.eventID, event.meal),
          Divider(),
          _allergens(event.eventID, event.allergies),
          Divider(),
          _guests(event.attendees, event.guestNum, event.seatsAvailable)
        ],
      )
    );
  }

  Widget _title(String title){
    return InkWell(
      onTap: null,
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title', style: TextStyle(color: Colors.black54)),
              Text('$title'),
            ],
          )),
    );
  }

  Widget _location(HumanatyLocation location){
    return InkWell(
      onTap: null,
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Location', style: TextStyle(color: Colors.black54)),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on, color: Pallete.humanGreen54),
                      Text('${location.city}, ${location.state}')
                    ],
                  )
                ],
              ),
              Text('${location.address}'),
              //Text('*potential guests will not see address until a seat is purchased', style: TextStyle(fontSize: 10))
            ],
          )),
    );
  }

  Widget _date(DateTime date){
    DateFormat f = DateFormat.yMMMMd("en_US").add_jm();
    return InkWell(
      onTap: null,
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Date and Time', style: TextStyle(color: Colors.black54)),
              Text('${f.format(date)}'),
            ],
          )),
    );
  }

  Widget _menu(String eventID, String menu){
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/meal_edit', arguments: {'eventID': eventID, 'meal': menu}),
      child: Row(
        children: <Widget>[
          Container(
              width: SizeConfig.screenWidth * .8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Menu', style: TextStyle(color: Colors.black54)),
                  Text('$menu'),
                ],
              )),
          _edit()
        ],
      ),
    );
  }

  Widget _allergens(String eventID, List allergens){
    return InkWell(
      onTap:() => Navigator.of(context)
          .pushNamed('/allergy_edit', arguments: {'allergyMap': Allergy().allergyMapFromList(allergens),
            'updateEvent': true, 'eventID': eventID}),
      child: Row(
        children: <Widget>[
          Container(
              width: SizeConfig.screenWidth * .8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Allergens', style: TextStyle(color: Colors.black54)),
                  Text('${Allergy().formattedStringFromList(allergens)}'),
                ],
              )),
          _edit()
        ],
      ),
    );
  }

  Widget _guests(List<Attendee> attendees, int guestNum, int seatsAvailable){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Guests', style: TextStyle(color: Colors.black54)),
            Text('${guestNum - seatsAvailable}/$guestNum Seats Filled')
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight * .02),
        Container(
          height: SizeConfig.screenHeight *.5,
          child: ListView.builder(
            itemCount: attendees.length,
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Card(
                  borderOnForeground: true,
                  child: Container(
                    color: Pallete.humanGreen54,
                    child: ListTile(
                        title: Text('${attendees[index].profile.displayName}'),
                        trailing: Text('${attendees[index].guests} Guest(s)'),
                        onTap:() => Navigator.of(context).pushNamed('/profile_display', arguments:{
                          'profile': attendees[index].profile,
                          'guests': attendees[index].guests
                        }),
                      ),
                  ),
                ),
              );
            }),
        )
      ],
    );
  }


  Widget _edit(){
    return InkWell(
      onTap: null,
      splashColor: Pallete.humanGreen54,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Pallete.humanGreen)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text('EDIT', style: TextStyle(color: Pallete.humanGreen),))));  
  }
}