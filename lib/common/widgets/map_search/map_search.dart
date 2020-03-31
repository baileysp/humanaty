import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:humanaty/models/user.dart';

class MapSearch extends SearchDelegate<String>{
   GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: 'AIzaSyDKNJ1TI_zJnzqBEmMzjlpw3tUBdoCK66g');
  
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed:() => query = '',)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed:() => close(context, null),
        icon: Icon(Icons.arrow_back, color: Colors.grey)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context){
    return FutureBuilder(future: search(), 
      builder:(BuildContext context, AsyncSnapshot<List<Prediction>> snapshot){      
        if (snapshot.hasData){
          List<Prediction> predictions = snapshot.data;
          return ListView.builder(
            itemCount: predictions.length,
            itemBuilder: (context, index){
              Prediction predLocation = predictions.elementAt(index);
              return ListTile(
                leading: Icon(Icons.location_on),
                title: Text(predLocation.description),
                onTap: () async{
                  HumanatyLocation location = await getLocationInfo(predLocation.placeId);
                  Navigator.of(context).pop(location.toString());             
                },
              );
            },
          );
        }
        return SizedBox(); 
      });
  }

  Future<List<Prediction>> search() async{
    if (query.isNotEmpty){
      PlacesAutocompleteResponse result = await _places.autocomplete(query, region: 'locality');
      if (result.errorMessage?.isNotEmpty == true || result.status == 'REQUEST_DENIED'){
        return null;
      }
      return result.predictions;
    }
    return null;
  }

  Future<HumanatyLocation> getLocationInfo(String placeId) async{ 
    PlacesDetailsResponse place = await _places.getDetailsByPlaceId(placeId);
    PlaceDetails placeDetail = place.result;
    String address = placeDetail.formattedAddress;
    Location coords = placeDetail.geometry.location;
    
    String city;
    String state;
    String zip;
    
    List components = placeDetail.addressComponents;
    for(int i = 0; i < components.length; i++){
      if(components[i].types.contains('administrative_area_level_1')) state = components[i].longName;
      if(components[i].types.contains('locality')) city = components[i].longName;
      if(components[i].types.contains('postal_code')) zip = components[i].longName;
    }
    
    HumanatyLocation location = HumanatyLocation(
      address: address, 
      city: city,
      geoPoint: GeoPoint(coords.lat, coords.lng),
      state: state,
      zip: zip);
    
    return location;
    
  }
  
}