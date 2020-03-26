import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/common/widgets/googlemaps/google_maps.dart';

class MapPage extends StatefulWidget{
  const MapPage({Key key}): super(key:key);
  
  
  _MapPageState createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[MapsWidget(), filter(context)],
        ),
        appBar:
            HumanatyAppBar(displayBackBtn: false, actions: [search(context)]));
  }

  Widget search(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.grey),
      onPressed: () => showSearch(context: context, delegate: MapSearch()),
    );
  }

  Widget filter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text("Date", style: TextStyle(fontSize: 16),),
              color: Colors.white, 
              onPressed: () {}),),
          SizedBox(width: 8),
          Expanded(
            child: RaisedButton(
              child: Text("Filters", style: TextStyle(fontSize: 16)),
              color: Colors.white, 
              onPressed: () {}))
        ],
      ),
    );
  }

  final Padding mapContainer = Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
          child: SizedBox(width: 350.0, height: 400.0, child: MapsWidget())));
}
