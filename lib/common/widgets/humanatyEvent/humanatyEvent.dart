import 'package:flutter/material.dart';
import 'package:humanaty/routes/events/events.dart';

class HumanatyEvent extends StatelessWidget {
  HumanatyEvent(
    {
      this.eventName,
      this.eventDate,
      this.eventDescription,
    }
  );

  String eventName;
  String eventDate;
  String eventDescription;

  HumanatyEvent.fromJson(Map<String, dynamic> json) {
    eventName = json['eventName'];
    eventDate = json['eventDate'];
    eventDescription = json['eventDescription'];
  }

  String getName() {
    return eventName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: new InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Events(
                eventName: this.eventName,
                eventDate: this.eventDate,
                eventDescription: this.eventDescription)
            )
          );
          print(eventName + " was clicked");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    Icon(Icons.event)
                  ],
                )
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(eventName, style: TextStyle(fontSize: 18)),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                          child: Text(eventDate)
                        ),
                      ],
                    ),
                    Text(eventDescription, style: TextStyle(fontWeight: FontWeight.w300)),
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }


}