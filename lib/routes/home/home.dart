import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        // shape: const CircularNotchedRectangle(),
        child: Container(height: 70.0)
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "settings",
              child: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            FloatingActionButton(
              heroTag: "map",
              child: Icon(Icons.map),
              onPressed: () {
                Navigator.pushNamed(context, '/map');
              },
            ),
            FloatingActionButton(
              heroTag: "events",
              child: Icon(Icons.ac_unit),
              onPressed: () {
                Navigator.pushNamed(context, '/events');
              },
            )
          ],
        )
      ),
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}