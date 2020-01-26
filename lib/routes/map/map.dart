import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/googleMapsWidget/maps.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Implement Map Page
      body: Center(
        child: Column(children: <Widget>[
          title,
          mapContainer
        ],)
      ),
    );
  }

 final Padding mapContainer =     
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          width: 350.0,
          height: 497.0,
          child: MapsWidget()
        )
      )
    );

  final Widget title = Container(
    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Text(
        "Humanaty",
        style: TextStyle(fontSize: 34),
      ),
    )
  );
}