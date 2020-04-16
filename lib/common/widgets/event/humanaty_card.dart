import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:humanaty/models/models.dart';

class HumanatyCard extends StatelessWidget {
  final HumanatyEvent event;
  HumanatyCard({this.event});

  @override
  Widget build(BuildContext context) {
    DateFormat f = DateFormat.yMMMMd("en_US");
    return Card(
      margin: EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: new InkWell(
        onTap: () {
          Navigator.of(context).pushNamed('/event_info', arguments:{'eventID': event.eventID});
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
                        Text(event.title, style: TextStyle(fontSize: 18)),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                          child: Text('${f.format(event.date)}')
                        ),
                      ],
                    ),
                    Text(event.description, style: TextStyle(fontWeight: FontWeight.w300)),
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