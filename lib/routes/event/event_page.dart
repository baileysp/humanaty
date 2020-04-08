
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  final HumanatyEvent currentEvent;
  EventPage({@required HumanatyEvent event}) : this.currentEvent = event;
  EventPageState createState() => new EventPageState(currentEvent);
}

class EventPageState extends State<EventPage> {
  TextEditingController _textFieldController = TextEditingController();
  EventPageState(this.event);
  final HumanatyEvent event;
  @override
  Widget build(BuildContext context) {
    // final _auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);
    return Scaffold(
        appBar: HumanatyAppBar(backgroundColor: Pallete.humanGreen ,fontColor: TextStyle(color: Colors.white), displayBackBtn: true, title: event.title),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(0,15,0,0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              hostedBy("Nancy Tester"),
              dateTile(event.date),
              menuEtc(event),
              purchaseBox(event.costPerSeat,(event.attendees == null) ? event.guestNum : event.guestNum - event.attendees.length)
            ]
          )
        ));
  }
}

// TODO Add a stream builder to this widget so it pulls real user data 
Widget hostedBy(String s) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Text("Hosted by",style: TextStyle(fontSize: 28,decoration: TextDecoration.underline)),
      Container(
            padding: const EdgeInsets.fromLTRB(10,0,0,0),
            child: CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/humanaty-gatech.appspot.com/o/defaultProfilePic%2FdefaultProfilePic.jpg?alt=media&token=e87a7526-daf8-4466-b186-e8703b1da31b'),
            backgroundColor: Pallete.humanGreen
            )
          ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(s, style: TextStyle(fontSize: 22)),
        ],
      ),
      Container(
        padding: EdgeInsets.only(bottom: 15),
        child: HumanatyRating(rating: 4, starSize: 15),
      )
    ],
  );
// return Container(
//   padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
//   child: Align(
//     alignment: Alignment.topLeft,
//     child: Text(
//       "Hosted by: " + s,
//       style: TextStyle(fontSize: 22),
//     ),
//   ));
}

Widget dateTile(DateTime d) {
  return Column(
    children: <Widget>[
      Row(children: <Widget>[
        Container(
          padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
          color: Pallete.humanGreenLight,
          child: Text("Event Date & Time: ", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
        
      ]),
    Container(
      alignment: Alignment.centerLeft,
          padding:EdgeInsets.fromLTRB(0, 2, 0, 10),
          // color: Pallete.humanGreen,
          child: Text("- Meal starts at " + (d.hour > 13 ? (d.hour - 12).toString(): d.hour.toString()) + ":" + d.minute.toString() + (d.hour > 13 ? "pm" : "am" ) + " on " + d.month.toString() + "/" + d.day.toString()+ "/" + d.year.toString(), style: TextStyle(color: Colors.black, fontSize: 18),),
        )
    ],
  );
}

Widget menuEtc(HumanatyEvent e) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
        Container(
          padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
          color: Pallete.humanGreenLight,
          child: Text("Menu: ", style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
    Container(
      alignment: Alignment.centerLeft,
          padding:EdgeInsets.fromLTRB(0, 2, 0, 10),
          // color: Pallete.humanGreen,
          child: genMenu(e.meal)
        ),
     Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
            Container(
              padding:EdgeInsets.fromLTRB(10, 0, 0, 0),
              color: Pallete.humanGreenLight,
              child: Text("Event Location:  ", style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
        Container(
          // alignment: Alignment.centerLeft,
              padding:EdgeInsets.fromLTRB(0, 2, 0, 20),
              // color: Pallete.humanGreen,
              child: Text("- " + e.location.city +" , " + e.location.state, style: TextStyle(color: Colors.black, fontSize: 18))
            ),
            
        ],
      )   
    ],
  );
}

Widget purchaseBox(double dollars, int seatsRemain) {
  int _num = 0;
  return Container(
    color: Pallete.humanGreenLight,
    alignment: Alignment.center,
    child: Column(
      children: <Widget>[
        Text("Purchase your Seats", style: TextStyle(color: Colors.white,decoration: TextDecoration.underline, fontSize: 22)),
        Text("Seats Remaining: " + seatsRemain.toString(), style: TextStyle(color: Colors.white,  fontSize: 18)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              child: Text("Quantity to Purchase: ", style: TextStyle(color: Colors.white,  fontSize: 18)),
              padding: EdgeInsets.only(left: 5,right: 20),
              ),
            // SizedBox(width: 10,
            //   child: TextField(
            //       controller: _textFieldController,
            //       keyboardType: TextInputType.number
            //     ),
            //   )
            DropdownButton<int>(style: TextStyle(color: Pallete.humanGreen, fontSize: 17), value: _num, items: genDropdown(seatsRemain), onChanged: (value) {
              _num = value;
            })
          ],
        ),
        Text("Cost per seat: " + "\$" +dollars.toString(), style: TextStyle(color: Colors.white,  fontSize: 18)),
        RaisedButton(disabledColor: Colors.white  ,disabledTextColor: Pallete.humanGreen, child: Text("Purchase with Stripe"))
      ],
    ), 
  );
}

List<DropdownMenuItem<int>> genDropdown(int seats) {
  List<DropdownMenuItem<int>> items = [];
  for (int i = 0; i <= seats; i++) {
    items.add(DropdownMenuItem(value: i, child: Text(i.toString())));
  }
  return items;
}

Text genMenu(String menu) {
  String result = "";
  List<String> temp = menu.split(",");
  for (String e in temp) {
    result += "- " + e.trim() + "\n";
  }
  return Text(result, style: TextStyle(color: Colors.black, fontSize: 18));
}