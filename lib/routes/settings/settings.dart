import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:url_launcher/url_launcher.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: auth.user.uid).userData,
        builder: (context, snapshot) {        
          if(snapshot.hasData){
            UserData userData = snapshot.data;
            return _settings(auth, userData);
          }
          return Loading();
        });
  }

  Widget _settings(AuthService auth, UserData userData) {
    return Scaffold(
      appBar: HumanatyAppBar(
          displayBackBtn: true,
          title: 'Settings',
      ),
      body: Column(
        children:[
          _currentLocation(context, auth, userData),
          Divider(height: 30),
          //_header('Legal'),
          //_nonFunctional('Terms of Service'),
          _nonFunctional('IP License'),
          //_nonFunctional('Software Licenses'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _logout(auth),
                    Text('huMANAty iOS App v1.0', style: TextStyle(color: Colors.black54)),
                  ],
                )
              ),
            )
          )
        ],  
      ),
    );
  }

  Widget _currentLocation(BuildContext context, AuthService auth, UserData userData){
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
        DatabaseService(uid: auth.user.uid).updateUserLocation(HumanatyLocation.fromString(location));
      },
    );
  }

  Widget _logout(AuthService auth){
    return Container(
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        onPressed: (){
          Navigator.pop(context);
          auth.signOut();
        },
        color: Pallete.humanGreen,
        child: Text('Log out', style: TextStyle(color: Colors.white, fontSize: 16.0))
      ),
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
    var url = 'https://github.com/bspencer30/humanaty';
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap:() async{
        if(await canLaunch(url)){
          await launch(url);
        }
      },
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
