import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/routes/profile/profile.dart';

class HumanatyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: _auth.user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData || _auth.status == Status.Anon) {
          UserData userData = snapshot.data;
          return drawer(_auth, userData, context);
        }
        //Navigator.pop(context);
        //_auth.signOut();
        return Loading();
      });
  }

  Widget drawer(AuthService _auth, UserData userData, BuildContext context) {
    return Drawer(
        child: ListView(
        children: <Widget>[
          DrawerHeader(child: _auth.status == Status.Anon ? anonHeader() : userHeader(userData)),
          profileTile(context, _auth.status, userData),
          settingsTile(),
          loginTile(context, _auth),
          Divider(),
          aboutTile()
        ],
    ));
  }

  Widget anonHeader(){
    return Container(
      padding: EdgeInsets.only(top: 32.0),
      child: Text('Welcome to huMANAty', style: TextStyle(fontSize: 16)));
  }

  Widget userHeader(UserData userData){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        if(userData.photoUrl != null) 
          CircleAvatar(radius: 70, 
            backgroundColor: Pallete.humanGreen,
            backgroundImage : NetworkImage(userData.photoUrl)),
        SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(userData.displayName, style: TextStyle(fontSize: 16)),
            HumanatyRating(rating: userData.consumerRating, starSize: 15)
        ],)
      ],
    );
  }

  Widget profileTile(BuildContext context, Status status, UserData userData){
    return ListTile(
      title: Text('Profile'),
      onTap: (){
        Navigator.pop(context);
        status == Status.Anon ? 
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Please Log-In to view your profile"))) :
          Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(userData: userData)));
      },);
  }

  Widget settingsTile(){
    return ListTile(
      title: Text('Settings'),
      onTap: (){},
    );
  }

  Widget loginTile(BuildContext context, AuthService _auth){
    return ListTile(
      title: Text(_auth.status == Status.Anon ? 'Login' : 'Sign Out'),
      onTap: () {
        Navigator.pop(context);
        _auth.signOut();
      },
    );
  }

  Widget aboutTile(){
    return ListTile(
      title: Text('About'),
      onTap: () {},
    );
  }
}