import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:humanaty/routes/_router.dart';

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
    //return Divider();
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
                  Location location = await getLocationInfo(predLocation.placeId);
                  close(context, "${location.lng} + ${location.lat}");
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                  
                  
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

  Future<Location> getLocationInfo(String placeId) async{ 
    PlacesDetailsResponse place = await _places.getDetailsByPlaceId(placeId);
    PlaceDetails placeDetail = place.result;
    Location location = placeDetail.geometry.location;
    //return placeDetail.geometry; 
    return location;
    //print(placeDetail.geometry.viewport);
  }
  
}