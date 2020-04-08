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
  EventPageState(this.event);
  final HumanatyEvent event;
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);
    return Scaffold(
        appBar: HumanatyAppBar(displayBackBtn: true, title: event.title),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              description
            ]
          )
        ));
  }
}


Widget description = Container(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "test",
          style: TextStyle(fontSize: 34),
        ),
      ));