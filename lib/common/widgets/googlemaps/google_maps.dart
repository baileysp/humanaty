import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsWidget extends StatefulWidget {
  
  
  @override
  State<MapsWidget> createState() => MapSampleState();
}

class MapSampleState extends State<MapsWidget> {
  BitmapDescriptor eventLocationPin;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 

  static final CameraPosition _startGTcampus =
      CameraPosition(target: LatLng(33.774745, -84.397445), zoom: 14.476);
  
  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.png').then((onValue) {
      eventLocationPin = onValue;
    });
  }

  // // void setEventPins() async {
  //   // eventLocationPin = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.png');
  // // }

  @override
  Widget build(BuildContext context) {
    // LatLng testPinPosition = ;
    return Scaffold(
      body: GoogleMap(
      myLocationButtonEnabled: true,
      markers: _markers,
      mapType: MapType.normal,
      initialCameraPosition: _startGTcampus,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId('1'),
            position: LatLng(33.774745, -84.397445),
            icon: eventLocationPin
          ));
        });
        
      },
    ));
  }
}
