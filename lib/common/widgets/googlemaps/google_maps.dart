import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/models/models.dart';

class MapsWidget extends StatefulWidget {
  final CollectionReference eventCollection = Firestore.instance.collection('events');
  Stream<List<HumanatyEvent>> get myEvents => eventCollection.snapshots().map(getLocations);
  HumanatyLocation location;
  MapsWidget({this.location});
  
  @override
  State<MapsWidget> createState() => MapSampleState();
}

List<HumanatyEvent> getLocations(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc){
      return HumanatyEvent(
        accessibilityAccommodations: doc.data['accessibilityAccommodations'],
        additionalInfo: doc.data['additionalInfo'],
        allergies: doc.data['allergies'],
        attendees: doc.data['attendees'],
        costPerSeat: doc.data['costPerSeat'],
        date: DateTime.parse(doc.data['date']),
        description: doc.data['description'],
        guestNum: doc.data['guestNum'],
        hostID: doc.data['hostID'],
        location: HumanatyLocation().humanantyLocationFromMap(doc.data['location']),
        meal: doc.data['meal'],
        //photoGallery: doc.data['photoGallery'],
        title: doc.data['title']
      );
    }).toList();
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
    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService().myEvents,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          print("This do have DATA \n");
          _createPins(snapshot.data);
        }
        // print(_markers);
        // print("\n\n\n\n\n");
        return Scaffold(
          body: GoogleMap(
          myLocationButtonEnabled: true,
          markers: _markers,
          // circles: _circles,
          mapType: MapType.normal,
          initialCameraPosition: _startPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            print(_markers);
            print("\n\n\n\n");
            // _createPins(snapshot.data);
            // int i = 3001;
            // setState(() {
            //   //_markers = _createPins(snapshot.data);
            //   MarkerId id = MarkerId("UXUI" + i.toString());
            //   for (HumanatyEvent e in snapshot.data) {
            //     print(LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude));
            //     _markers.add(Marker(
            //       markerId: id,
            //       position: LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude),
            //       icon: BitmapDescriptor.defaultMarkerWithHue(164)
            //     ));
            //     i++;
            //   }
            // });
          },
        ));
      });
  }

  void _createPins(List<HumanatyEvent> events) {
    int i = 3001;
    Set<Marker> markers = {};
    for (HumanatyEvent e in events) {
      MarkerId id = MarkerId("UXUI" + i.toString());
      print(id);
      // print(LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude));
      markers.add(Marker(
        markerId: id,
        position: LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(164)
        ));
      i++;
    }
    setState(() {
        _markers = markers;
      });
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
