import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';

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

  humanatyLocationNoCoords(String address, String city, String state, String zip) async{
    GeoPoint geoPoint = await _lookup(address);
    HumanatyLocation location = HumanatyLocation(
      address: address,
      city: city,
      geoPoint: geoPoint,
      state: state,
      zip: zip
    );
    return location;
  }

  Future<GeoPoint> _lookup(String address)async{
    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyDKNJ1TI_zJnzqBEmMzjlpw3tUBdoCK66g');
    PlacesSearchResponse _response = await _places.searchByText(address + city + state);
    List<PlacesSearchResult> _results = _response.results;
    if(_results.isNotEmpty){
      PlacesSearchResult _result = _results[0];
      Location location = _result.geometry.location;
      return GeoPoint(location.lat, location.lng);
    } else{
      return GeoPoint(0,0);
    }
  }

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