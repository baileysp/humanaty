import 'package:flutter/material.dart';

class HumanatyEvent extends StatelessWidget {
  HumanatyEvent(
    {
      this.eventName,
      this.eventDate,
      this.eventDescription
    }
  );

  final String eventName;
  final String eventDate;
  final String eventDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: new InkWell(
        onTap: () {

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
                    Text(eventName),
                    Text(eventDate),
                    Text(eventDescription),
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