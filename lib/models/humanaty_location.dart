import 'package:cloud_firestore/cloud_firestore.dart';

class HumanatyLocation {
  String address;
  String city;
  GeoPoint geoPoint;  
  String state;
  String zip;
  
  HumanatyLocation({
    this.address,
    this.city,
    this.geoPoint = const GeoPoint(0, 0),  
    this.state,  
    this.zip
  });

  HumanatyLocation.fromString(String string){
    List list = string.split('|');
    this.address = list[0];
    this.city = list[1];
    List coords = list[2].split('*');
    this.geoPoint = GeoPoint(double.parse(coords[0]), double.parse(coords[1]));
    this.state = list[3];
    this.zip = list[4];
  }  

  humanantyLocationFromMap(Map<dynamic, dynamic> location){
    try{
      return HumanatyLocation(
      address: location['address'].toString(),
      city: location['city'].toString(),
      geoPoint: location['coordinates'] ?? GeoPoint(33.774745,-84.397445),
      state: location['state'],
      zip: location['zip']
    );
    } catch(error){
      print(error);
    }
  }

  bool isEmpty() => address == null;

  bool isNotEmpty() => address != null;
  
  @override
  String toString() => '$address|$city|${geoPoint.latitude}*${geoPoint.longitude}|$state|$zip';

}