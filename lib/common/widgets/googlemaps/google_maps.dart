import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/util/logger.dart';
import 'package:humanaty/services/database.dart';

class MapsWidget extends StatefulWidget {
  final CollectionReference eventCollection = Firestore.instance.collection('events');
  Stream<List<HumanatyEvent>> get myEvents => eventCollection.snapshots().map(getLocations);
  
  
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
  BitmapDescriptor eventLocationPin;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 

  static final CameraPosition _startGTcampus =
      CameraPosition(target: LatLng(33.774745, -84.397445), zoom: 14.476);
  
  @override
  void initState() {
    super.initState();
    setEventPins();
  }

  void setEventPins()  {
    // eventLocationPin = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/event_pin.png');
    eventLocationPin = BitmapDescriptor.defaultMarkerWithHue(164);
  }

  @override
  Widget build(BuildContext context) {
    bool yikes = false;
    // _markers.add(Marker(
    //         markerId: MarkerId('1'),
    //         position: LatLng(33.774745, -84.397445),
    //         icon: eventLocationPin
    //       ));
    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService().myEvents,
      builder: (context, snapshot){
        if (snapshot.hasData) {
          print("This do have DATA \n");
          _markers = _createPins(snapshot.data);
        }
        print(_markers);
        print("\n\n\n\n\n");
        return Scaffold(
          body: GoogleMap(
          myLocationButtonEnabled: true,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: _startGTcampus,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            // setState(() {
            //   _markers.add(Marker(
            //     markerId: MarkerId('1'),
            //     position: LatLng(33.774745, -84.397445),
            //     icon: eventLocationPin
            //   ));
            // });
            
          },
        ));
      });
    
  }

  Set<Marker> _createPins(List<HumanatyEvent> events) {
    int i = 3001;
    Set<Marker> markers = {};
    for (HumanatyEvent e in events) {
      MarkerId id = MarkerId("UXUI" + i.toString());
      print(LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude));
      markers.add(Marker(
        markerId: id,
        position: LatLng(e.location.geoPoint.latitude,e.location.geoPoint.longitude),
        icon: eventLocationPin
      ));
      i++;
    }
    return markers;
  }
}
