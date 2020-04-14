import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/logger.dart';


class FarmMaps extends StatefulWidget {
  final HumanatyLocation location;
  FarmMaps({this.location});
  @override
  _FarmMapsState createState() => _FarmMapsState();
}

class _FarmMapsState extends State<FarmMaps>{
  final log = getLogger('Farm Maps');
  AuthService _auth;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {}; 

  CameraPosition _startPosition = CameraPosition(target: LatLng(33.774745,-84.397445), zoom: 14.476);
  

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthService>(context);

    return StreamBuilder<List<HumanatyFarm>>(
      stream: DatabaseService(uid: _auth.user.uid).getFarms(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          List<HumanatyFarm> farms = snapshot.data;
          _createPins(farms);
        }
        return Scaffold(
          body: GoogleMap(
          myLocationButtonEnabled: true,
          markers: _markers,
          mapType: MapType.normal,
          initialCameraPosition: _startPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ));
      }
    ); 
  }

  void _createPins(List<HumanatyFarm> farms) {
    log.v('Pulled ${farms.length} farms from database.');
    Set<Marker> markers = {};
    for(int i = 0; i < farms.length; i++){
      HumanatyFarm farm = farms[i];
      MarkerId id = MarkerId(i.toString());
      markers.add(Marker(
        markerId: id,
        position: LatLng(farm.location.geoPoint.latitude, farm.location.geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(164),
        consumeTapEvents: true,
        onTap: () {
          // Navigator.pop(context);
          //Navigator.of(context).pushNamed('/event', arguments: {'event': event});
          //Navigator.of(context).pushNamed('/event_info', arguments: {'eventID': event.eventID});
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
  void didUpdateWidget(FarmMaps oldWidget) {
    if(widget.location != oldWidget.location){
      _moveCamera(widget.location.geoPoint);
    }
    super.didUpdateWidget(oldWidget);
  }
  
}