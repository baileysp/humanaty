import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';

/*
  TODO: Set up body parameter so it switches to correct page (navigation/routing)
 */
class Home extends StatefulWidget {
  final FirebaseUser user;
  Home({Key key, this.user}) : super(key: key);
  
  @override 
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int navIndex = 0;
  static const TextStyle navStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("Settings")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text("Map")),
        ],
        currentIndex: navIndex,
        selectedItemColor: Colors.amber[800],
        onTap: selectNav,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Home Page"),
            signOut()
          ],
        ),
      ),
    );
  }

  void selectNav(int index) {
    setState(() {
      navIndex = index;
    });
  }

  Widget signOut() {
    return FlatButton(
      color: Colors.blue,
      onPressed: (){
        print(context.describeOwnershipChain('/home'));
        Provider.of<AuthService>(context, listen: false).signOut();},
      child: Text("Sign Out")
    );
  }
}
