import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
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
              (snapshot.hasData) ? snapshot.data : null;
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
          //_header('Location'),
          _currentLocation(context, _auth, userData),
          Divider(),
          //_header('App'),
          _logout(_auth),
          //_version(),
          Divider(),
          //_header('Legal'),
          //_nonFunctional('Terms of Service'),
          _nonFunctional('IP License'),
          //_nonFunctional('Software Licenses'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('huMANAty iOS App v1.0', style: TextStyle(color: Colors.black54))
              ),
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
      trailing: IconButton(icon: Icon(Icons.location_on), onPressed: (){}),
      subtitle: Row(
      mainAxisSize: MainAxisSize.min,
       children: <Widget>[
          Text((userData?.location?.address == null) ? 'No Location Set' : userData?.location?.address),
       ],
      ),
      onTap:() async{
        String location = await showSearch(context: context, delegate: MapSearch());
        if(location == null) return;
        DatabaseService(uid: _auth.user.uid).updateUserLocation(HumanatyLocation.fromString(location));
      },
    );
  }

  Widget _logout(AuthService _auth){
    return ListTile(
      title: Text('Logout', ),//style: TextStyle(color: Pallete.humanGreen),),
      onTap: (){
        Navigator.pop(context);
        _auth.signOut();
      },
    );
  }

  Widget _version(){
    return ListTile(
      title: Text('huMANAty iOS App'),
      trailing: Text('v1.0'),
    );
  }

  Widget _header(String header){
    return Container(
      width: double.infinity,
      height: 50,
      //color: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(header, 
            style:TextStyle(fontSize: 18.0, )))//fontWeight: FontWeight.w600),))
      ),
    );
  }

  Widget _nonFunctional(String title){
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: (){},
    );
  }

  void location() async{
    GeolocationStatus geolocationStatus  = await Geolocator().checkGeolocationPermissionStatus();
    if(geolocationStatus == GeolocationStatus.granted){
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
      print(placemark);
    }
  }


}
