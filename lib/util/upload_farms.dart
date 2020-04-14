import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:humanaty/models/models.dart';
import 'package:humanaty/util/logger.dart';

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
    print('--- Parse json from: $assetsPath');
    return rootBundle.loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

void uploadFarms() async{
  final log = getLogger('Upload Farms');
  Firestore _databaseRef = Firestore.instance;
  final CollectionReference farmCollection = _databaseRef.collection('farmers');

  Map<String, dynamic> dmap = await parseJsonFromAssets('assets/farms/farms.json');
  dmap.forEach((key, value) async{
    Map<String, dynamic> farm = Map.from(value);
    DocumentReference documentReference = farmCollection.document();
    HumanatyLocation location = await HumanatyLocation().humanatyLocationNoCoords(
      farm['address'],
      farm['city'],
      farm['state'],
      farm['zip'].toString()
    );
    documentReference.setData({
      'contact': farm['contact'],
      'email': farm['email'],
      'farmID': documentReference.documentID,
      'location': {
        'address': location.address,
        'city': location.city,
        'coordinates': location.geoPoint,
        'state': location.state,
        'zip': location.zip
      },
      'name': farm['name'],
      'telephone': farm['telephone'],
      'website': farm['website'],
    }).then((_){
      log.v('Successfully added: ${farm['name']} to Firestore');
    });
  });
}


