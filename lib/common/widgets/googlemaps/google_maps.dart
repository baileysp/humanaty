import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/models/models.dart';

class MapsWidget extends StatefulWidget {
  HumanatyLocation location;
  MapsWidget({this.location});
  
  @override
  State<MapsWidget> createState() => MapSampleState();
}

class MapSampleState extends State<MapsWidget> {
  BitmapDescriptor eventLocationPin;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 
  Set<Circle> _circles = {};

  static final CameraPosition _startGTcampus =
      CameraPosition(target: LatLng(33.774745, -84.397445), zoom: 14.476);
  
  CameraPosition _startPosition = CameraPosition(target: LatLng(33.774745,-84.397445), zoom: 14.476);

  @override
  void initState() {
    super.initState();
    //print(widget.location);
    //print('making map');
    //_startPosition = CameraPosition(target: LatLng(33.774745,-84.397445), zoom: 14.476);
    //BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.p ))
    //BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.png').then((onValue) {
      //eventLocationPin = onValue;
    //});
  }

  // // void setEventPins() async {
  //   // eventLocationPin = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.png');
  // // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
      myLocationButtonEnabled: true,
      markers: _markers,
      circles: _circles,
      mapType: MapType.normal,
      initialCameraPosition: _startPosition,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        setState(() {
          print('test');
          _markers.add(Marker(
            markerId: MarkerId('1'),
            position: LatLng(33.774745, -84.397445),
            icon: BitmapDescriptor.defaultMarkerWithHue(164)//eventLocationPin
          ));
        });
        
      },
    ));
  }

  void _moveCamera(GeoPoint geopoint) async{
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(geopoint.latitude, geopoint.longitude), zoom: 14.476
      )));
    });
  }

  @override 
  void didUpdateWidget(MapsWidget oldWidget) {
    if(widget.location != oldWidget.location){
      _moveCamera(widget.location.geoPoint);
    }
    super.didUpdateWidget(oldWidget);
  }

}
