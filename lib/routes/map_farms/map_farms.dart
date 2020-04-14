import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/routes/_router.dart';

class MapFarms extends StatefulWidget {
  const MapFarms({Key key}) : super(key: key);
  @override
  _MapFarmsState createState() => _MapFarmsState();
}

class _MapFarmsState extends State<MapFarms> {
  HumanatyLocation _location;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            FarmMaps(location: _location),
            
          ],
        ),
        appBar: HumanatyAppBar(
          displayBackBtn: false,
          title: _location?.city ?? 'Search By Region',
          actions: [_search(context)],
        ));
  }

  Widget _search(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.grey),
      onPressed: () async {
        String location =
            await showSearch(context: context, delegate: MapSearch());
        print(location);
        if (location != null) {
          setState(() {
            _location = HumanatyLocation.fromString(location);
          });
          print(_location);
        }
      },
    );
  }
}
