import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/routes/event/event_page.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/models/models.dart';
import 'package:provider/provider.dart';

class MapsWidget extends StatefulWidget {
  
  
  HumanatyLocation location;
  MapsWidget({this.location});
  
  @override
  State<MapsWidget> createState() => MapSampleState();
}

// Set<Marker> getPins() {
//    = myEvents;
// }

class MapSampleState extends State<MapsWidget> {
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
        if (snapshot.hasData) {
          List<HumanatyEvent> tempList = snapshot.data;
          for (HumanatyEvent e in tempList) {
            print(e.title);
            print("\n\n\n");
          }
          _createPins(tempList);
          print(tempList.length);
        }
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
        icon: BitmapDescriptor.defaultMarkerWithHue(164),
        consumeTapEvents: true,
        onTap: () {
          // Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EventPage(event: event)));
        }
        ));
      _markers = markers;
    }
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
  void didUpdateWidget(MapsWidget oldWidget) {
    if(widget.location != oldWidget.location){
      _moveCamera(widget.location.geoPoint);
    }
    super.didUpdateWidget(oldWidget);
  }

}

