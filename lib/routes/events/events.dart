import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(this.eventName),
      ),
      body: Center(
        child: Text(this.eventDescription),
      ),
    );
  }
}