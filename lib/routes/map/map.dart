import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets/googleMapsWidget/maps.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //TODO: Implement Map Page
      body: Center(
        child: Column(children: <Widget>[
          title,
          mapContainer
        ],)
      ),
      appBar: AppBar(
        title: Text("search map.."),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed:() {
            showSearch(context:context,delegate:MapSearch());
          })
        ],
      ),
    );
  }

 final Padding mapContainer =     
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: SizedBox(
          width: 350.0,
          height: 400.0,
          child: MapsWidget()
        )
      )
    );

  final Widget title = Container(
    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Text(
        "Humanaty",
        style: TextStyle(fontSize: 34),
      ),
    )
  );
}
class MapSearch extends SearchDelegate<String>{
  @override
  final cities = [
      "Atlanta",
      "HongKong",
      "Savannah",
      "Jimmy",
      "Liam",
      "Liiam",
      "Liiaam"
  ];

  final recentCities = [
      "HongKong",
      "Jimmy",
      "Liam"
  ];
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return[
      IconButton(icon: Icon(Icons.clear), onPressed: (){
        query = "";
      },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
    
    ),
    onPressed: (){
      close(context,null);
    });
    

  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: show result of search
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.red,
        child: Center(child: Text(query))
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    final suggestuonList = query.isEmpty 
          ? recentCities
          :cities.where((p)=>p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index)=> ListTile(
        onTap:(){
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(text: TextSpan(
          text: suggestuonList[index].substring(0,query.length),
          style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
            text:suggestuonList[index].substring(query.length),
            style: TextStyle(color: Colors.grey)
          )]
            ),
          ),
        ),
      itemCount: suggestuonList.length,
    );
  }
}