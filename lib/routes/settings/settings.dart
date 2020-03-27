import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  final UserData prevUserData;
  const Settings({Key key, this.prevUserData}) : super(key: key);
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _auth.user.uid).userData,
        builder: (context, snapshot) {
          UserData userData =
              (snapshot.hasData) ? snapshot.data : widget.prevUserData;
          return _settings(context, _auth, userData);
        });
  }

  Widget _settings(BuildContext context, AuthService _auth, UserData userData) {
    return Scaffold(
      appBar: HumanatyAppBar(
          displayBackBtn: true,
          title: 'Settings',
      ),
      body: Column(
        children: <Widget>[
          _currentLocation(context, _auth, userData)
        ],
      )
    );
  }

  Widget _currentLocation(BuildContext context, AuthService _auth, UserData userData){
    return ListTile(
      title: Text('Current Location'),
      trailing: Row(
      mainAxisSize: MainAxisSize.min,
       children: <Widget>[
          Text((userData.location.address == null) ? 'No Idea' : userData.location.address),
          IconButton(
            icon: Icon(Icons.location_on), 
            onPressed: (){//get users location
            },)
       ],
      ),
      onTap:() async{
        String returnString = await showSearch(context: context, delegate: MapSearch());
        if(returnString == null) return;

        List<String> locationList = returnString.split('|');
        String addr = locationList[0];
        List coordsList = locationList[1].trim().split(' ');
        GeoPoint coords = GeoPoint(double.parse(coordsList[0]), double.parse(coordsList[1]));
        HumanatyLocation location = HumanatyLocation(address: addr, geoPoint: coords);
        DatabaseService(uid: _auth.user.uid).updateUserLocation(location);
                
        print(userData.location);
      },
    );
  }
}
