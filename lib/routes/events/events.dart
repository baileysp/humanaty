import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/models/humanaty_event.dart';
import 'package:humanaty/common/design.dart';

class Events extends StatelessWidget {
  
  Events(
    {
      this.eventName,
      this.eventDate,
      this.eventDescription,
    }
  );

  String eventName;
  String eventDate;
  String eventDescription;
  @override
  Widget build(BuildContext context) {
    //Hard coded fields here for now
    bool accessibilityAccommodations = false;
    String additionalInfo = "Additional info here";
    List<String> allergies = ["Allergy 1", "Allergy 2"];
    int attendees = 10;
    int costPerSeat = 50;
    String date = "Date here";
    List<String> farms = ["Farm 1", "Farm 2"];
    var location = {
      "address": "123 Lane Road",
      "city": "Atlanta",
      "geopoint": {
        "state": "GA",
        "zip": 30313
      }
    };
    String meal = "add";
    List<String> photoGallery = ["Photo 1 here", "Photo 2 here"];
    String title = "Event title";

    return Scaffold(
      appBar: AppBar(
        title: Text(this.eventName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("1"),
            Text("1"),
            _buyButton()
          ],
        ),
      )
    );
  }
}

Widget _photoGallery() {
  //TODO: Make photo gallery, found some plugin called PhotoView that might be able to handle this
}

Widget _eventInfo() {
  
}

Widget _buyButton() {
  return Align(
      alignment: Alignment.bottomCenter,
      child: RaisedButton(
      color: Pallete.humanGreenLight,
      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
      child: Text(
        "Reserve a seat",
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        //TODO: Send user to payment screen
        print("Buy button clicked");
      }
    ),
  );
}