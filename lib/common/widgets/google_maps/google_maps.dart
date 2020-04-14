import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/models/models.dart';


class GoogleMaps extends StatefulWidget {
    
  final HumanatyLocation location;
  GoogleMaps({this.location});
  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}




class _GoogleMapsState extends State<GoogleMaps> {


  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 
  Set<Circle> _circles = {};
  BitmapDescriptor _customIcon;
  CameraPosition _startPosition = CameraPosition(target: LatLng(33.774745,-84.397445), zoom: 14.476);

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48,48)), 'assets/images/event_pin.png')
      .then((onValue){
        _customIcon = onValue;
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return StreamBuilder<List<HumanatyEvent>>(
      stream: DatabaseService(uid: auth.user.uid).getEvents(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          List<HumanatyEvent> events = snapshot.data;
          _createPins(events);
          _createCircle(events);
        }
        return Scaffold(
          body: GoogleMap(
          myLocationButtonEnabled: true,
          markers: _markers,
          //circles: _circles,
          mapType: MapType.normal,
          initialCameraPosition: _startPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
      });
  }

  Future<void> _createPins(List<HumanatyEvent> events)async {
    print(events.length);
    Set<Marker> markers = {};
    for(int i = 0; i < events.length; i++){
      HumanatyEvent event = events[i];
      MarkerId id = MarkerId(i.toString());
      markers.add(Marker(
        markerId: id,
        position: LatLng(event.location.geoPoint.latitude, event.location.geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(164),
        //icon: _customIcon,
        consumeTapEvents: true,
        onTap: () {
          Navigator.of(context).pushNamed('/event_info', arguments: {'eventID': event.eventID});
        }
        ));
      _markers = markers;
    }
  }

  void _createCircle(List<HumanatyEvent> events){
    Set<Circle> circles = {};
    for(int i = 0; i < events.length; i++){
      HumanatyEvent event = events[i];
      CircleId id = CircleId(i.toString());
      circles.add(Circle(
        circleId: id,
        consumeTapEvents: true,
        fillColor: Pallete.humanGreen54,
        center: _offset(event.location.geoPoint),
        radius: 1609,
        //strokeColor: Pallete.humanGreen,
        strokeWidth: 1,
        zIndex: i
      ));
    _circles = circles;
    }
  }

  LatLng _offset(GeoPoint center){
    Random _rand = Random(DateTime.now().millisecond);
    double _offset = .5; //max offset in miles of lat and lang
    double _latoff = (_rand.nextDouble() * (2*_offset) - _offset)/69;
    double _lngoff = (_rand.nextDouble() * (2*_offset) - _offset)/69; 
    return LatLng(center.latitude + _latoff, center.longitude + _lngoff);    
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

