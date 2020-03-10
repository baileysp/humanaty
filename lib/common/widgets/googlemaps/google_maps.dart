import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  
  
  @override
  State<MapsWidget> createState() => MapSampleState();
}

class MapSampleState extends State<MapsWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _startGTcampus =
      CameraPosition(target: LatLng(33.774745, -84.397445), zoom: 14.476);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _startGTcampus,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    ));
  }
}
