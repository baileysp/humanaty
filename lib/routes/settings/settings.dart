import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';


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
        children:[
          _currentLocation(context, _auth, userData),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 10.0, right: 10.0, top:250.0, bottom: 10.0),
            child: RaisedButton(
              textColor: Colors.deepPurple,
              color: Colors.greenAccent,
              child:Text("Log Out"),
              onPressed: (){
                     Navigator.pop(context);
                     _auth.signOut();
              },
            )
          )
        ],  
      ),
    );
  }

  Widget _currentLocation(BuildContext context, AuthService _auth, UserData userData){
    return ListTile(
      isThreeLine: true,
      title: Text('Current Location'),
      trailing: IconButton(icon: Icon(Icons.location_on), onPressed: null),
      subtitle: Row(
      mainAxisSize: MainAxisSize.min,
       children: <Widget>[
          Text((userData.location.address == null) ? 'No Idea' : userData.location.address),
       ],
      ),
      onTap:() async{
        String location = await showSearch(context: context, delegate: MapSearch());
        if(location == null) return;
        DatabaseService(uid: _auth.user.uid).updateUserLocation(HumanatyLocation.fromString(location));
      },
    );
  }
}
