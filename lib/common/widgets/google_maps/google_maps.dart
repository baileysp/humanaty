import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/models/models.dart';
import 'package:provider/provider.dart';

class GoogleMaps extends StatefulWidget {
  
  
  HumanatyLocation location;
  GoogleMaps({this.location});
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

// Set<Marker> getPins() {
//    = myEvents;
// }

class _GoogleMapsState extends State<GoogleMaps> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 
  // Set<Circle> _circles = {};
  
  CameraPosition _startPosition = CameraPosition(target: LatLng(33.774745,-84.397445), zoom: 14.476);

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService(uid: _auth.user.uid).getEvents(),
      builder: (context, snapshot){
        if (snapshot.hasData) _createPins(snapshot.data);
        print(_markers.length);
        return Scaffold(
          body: GoogleMap(
          myLocationButtonEnabled: true,
          markers: _markers,
          // circles: _circles,
          mapType: MapType.normal,
          initialCameraPosition: _startPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
      });
  }

  void _createPins(List<HumanatyEvent> events) {
    print(events.length);
    Set<Marker> markers = {};
    for(int i = 0; i < events.length; i++){
      HumanatyEvent event = events[i];
      MarkerId id = MarkerId(event.hashCode.toString());
      print(id);
      markers.add(Marker(
        markerId: id,
        position: LatLng(event.location.geoPoint.latitude, event.location.geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(164)
        ));
      _markers = markers;
      setState(() {
        //_markers = markers;
      });
    }
    //print(_markers);
  }

  void _moveCamera(GeoPoint geopoint) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(geopoint.latitude, geopoint.longitude), zoom: 14.476
      )));
    });
  }

  @override 
  void didUpdateWidget(GoogleMaps oldWidget) {
    if(widget.location != oldWidget.location){
      _moveCamera(widget.location.geoPoint);
    }
    super.didUpdateWidget(oldWidget);
  }

}

