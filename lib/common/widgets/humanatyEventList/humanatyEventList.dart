import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/event/humanatyEvent.dart';

class HumanatyEventList extends StatelessWidget {
  HumanatyEventList(
    {
      this.events
    }
  );

  final List<HumanatyEvent2> events;
  @override
  Widget build(BuildContext context) {
    return Column(children: events);
  }
}