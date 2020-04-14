import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventInfo extends StatefulWidget {
  final String eventID;
  EventInfo({this.eventID});
  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  AuthService auth;
  DatabaseService database;
  int _seatsToPurchase;

  @override
  void initState() {
    _seatsToPurchase = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);

    return StreamBuilder<HumanatyEvent>(
        stream: database.getEvent(widget.eventID),
        builder: (context, snapshot) {
          print(snapshot.hasData);
          if (snapshot.hasData) {
            HumanatyEvent event = snapshot.data;
            print(event.title);
            if (event.seatsAvailable > 0) {
              return _build(event);
            } else {
              print('seats no longer available');
              Navigator.pop(context);
            }
          } else {
            return Scaffold(
                appBar: HumanatyAppBar(
                    backgroundColor: Pallete.humanGreen, displayBackBtn: true),
                body: Placeholder());
          }
        });
  }

  Widget _build(HumanatyEvent event) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: HumanatyAppBar(
            backgroundColor: Pallete.humanGreen,
            displayBackBtn: true,
            title: '${event.title}',
            titleStyle: TextStyle(color: Colors.white)),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _hostInfo(event),
            SizedBox(height: SizeConfig.screenHeight * .025),
            _description(
                event.title, event.description, event.location, event.date),
            SizedBox(height: SizeConfig.screenHeight * .05),
            Divider(),
            _menu(event.meal, event.allergies),
            Divider(),
            _additional(
                event.additionalInfo, event.accessibilityAccommodations),
            Divider(height: 20),
            _pricing(event.seatsAvailable)
          ],
        ));
  }

  Widget _hostInfo(HumanatyEvent event) {
    return StreamBuilder<Profile>(
        stream: database.getProfile(event.hostID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Profile hostProfile = snapshot.data;
            return Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Pallete.humanGreen54,
                    backgroundImage: NetworkImage(hostProfile.photoUrl),
                    radius: 50),
                SizedBox(width: SizeConfig.screenWidth * .05),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('${hostProfile.displayName}',
                        style: TextStyle(fontSize: 20)),
                    HumanatyRating(
                      rating: hostProfile.hostRating,
                      starSize: 12,
                    ),
                  ],
                )
              ],
            );
          } else {
            return ListTile(title: Text('Loading'));
          }
        });
  }

  Widget _description(String title, String description,
      HumanatyLocation location, DateTime date) {
    DateFormat f = DateFormat.yMMMMd("en_US").add_jm();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(title, style: TextStyle(fontSize: 17)),
            Row(
              children: <Widget>[
                Icon(Icons.location_on, color: Pallete.humanGreen54),
                Text('${location.city}, ${location.state}')
              ],
            )
          ],
        ),
        Text(description),
        Text('${f.format(date)}')
      ],
    );
  }

  Widget _date(DateTime date) {
    DateFormat f = DateFormat.yMMMMd("en_US").add_jm();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Date and Time', style: TextStyle(fontSize: 17)),
        Text(
          '${f.format(date)}',
          style: TextStyle(),
        )
      ],
    );
  }

  Widget _menu(String menu, List allergies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Menu', style: TextStyle(fontSize: 17)),
        Text(
          menu,
          style: TextStyle(),
        ),
        Visibility(
          visible: allergies.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.error, color: Colors.red.withOpacity(.54)),
              Text('Allergens: '),
              Text('${Allergy().formattedStringFromList(allergies)}')
            ],
          ),
        )
      ],
    );
  }

  Widget _additional(String additionalInfo, bool access) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Additional Information', style: TextStyle(fontSize: 17)),
        Visibility(
            visible: additionalInfo.isNotEmpty, child: Text(additionalInfo)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(access
                ? 'Accessibility Accomodations'
                : 'No Accessibility Accomodations'),
            Icon(access ? Icons.accessible_forward : Icons.accessibility_new,
                color: access ? Pallete.humanGreen54 : Colors.black54)
          ],
        )
      ],
    );
  }

  Widget _pricing(int seatsAvailable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Purchase Your Seats', style: TextStyle(fontSize: 17)),
            Text('$seatsAvailable Seats Remaining')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('$_seatsToPurchase Guest'),
            Row(
              children: <Widget>[
                Container(
                  width: 30,
                  child: IconButton(
                    onPressed: (){
                      if(_seatsToPurchase  < seatsAvailable){
                        setState(() {
                          _seatsToPurchase += 1;
                        });
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    icon: Icon(Icons.add,color: Pallete.humanGreen, size: 24,
                  )),
                ),
                Container(
                  width: 30,
                  child: IconButton(
                    onPressed: (){
                      if(_seatsToPurchase - 1 > 0){
                        setState(() {
                          _seatsToPurchase -= 1;
                        });
                      }
                    },
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    icon: Icon(Icons.remove,color: Pallete.humanGreen, size: 24)),
                )
              ],
            )
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight * .05),
        Container(
          width: double.infinity,
          height: 50.0,
          child: RaisedButton(
            onPressed: (){},
            color: Pallete.humanGreen,
            child: Text('Purchase $_seatsToPurchase Seats', style: TextStyle(color: Colors.white))
          ),
        )
      ],
    );
  }
}
