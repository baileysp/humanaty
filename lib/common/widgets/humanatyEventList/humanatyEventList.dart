import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/humanatyEvent/humanatyEvent.dart';

class HumanatyEventList extends StatelessWidget {
  HumanatyEventList(
    {
      this.events
    }
  );

  final List<HumanatyEvent> events;
  @override
  Widget build(BuildContext context) {
    return Column(children: events);
  }
}