import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/app_mode.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/routes/profile/profile.dart';
import 'package:flutter_svg/svg.dart';

class HumanatyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    final _mode = Provider.of<AppMode>(context);
    print(_mode.mode);    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: _auth.user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData || _auth.isAnonUser()) {
          UserData userData = snapshot.data;
          return drawer(context, _auth, userData, _mode);
        }
        print(snapshot);
        //Navigator.pop(context);
        //_auth.signOut();
        return Loading();
      });
  }

  Widget drawer(BuildContext context, AuthService _auth, UserData userData, AppMode _mode) {
    return Drawer(
        child: ListView(
        children: <Widget>[
          DrawerHeader(child: _auth.isAnonUser() ? _anonHeader() : _userHeader(context, userData)),
          _profileTile(context, _auth.status, userData),
          _settingsTile(context, userData),
          _loginTile(context, _auth),
          Divider(),
          _aboutTile(),
          _switchModeTile(context, _mode)
        ],
    ));
  }

  Widget _anonHeader(){
    return Container(
      padding: EdgeInsets.only(top: 32.0),
      child: Text('Welcome to huMANAty', style: TextStyle(fontSize: 16)));
  }

  Widget _userHeader(BuildContext context, UserData userData){
    //print(userData.photoUrl);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(prevUserData: userData)));
          },
          child: CircleAvatar(radius: 70, 
            backgroundColor: Pallete.humanGreen,
            backgroundImage : NetworkImage(userData.photoUrl)),),
        SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(userData.displayName, style: TextStyle(fontSize: 16)),
            HumanatyRating(rating: userData.guestRating, starSize: 15)
        ],)
      ],
    );
  }

  Widget _profileTile(BuildContext context, Status status, UserData userData){
    return ListTile(
      title: Text('Profile'),
      onTap: (){
        Navigator.pop(context);
        status == Status.Anon ? 
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Please Log-In to view your profile'))) :
          Navigator.push(context,MaterialPageRoute(builder: (context) => Profile(prevUserData: userData)));
      },);
  }

  Widget _settingsTile(BuildContext context, UserData userData){
    return ListTile(
      title: Text('Settings'),
      onTap: (){Navigator.of(context).pushNamed('/settings', arguments: userData);},
    );
  }

  Widget _loginTile(BuildContext context, AuthService _auth){
    return ListTile(
      title: Text(_auth.isAnonUser() ? 'Login' : 'Sign Out'),
      onTap: () {
        Navigator.pop(context);
        _auth.signOut();
      },
    );
  }

  Widget _aboutTile(){
    return ListTile(
      title: Text('About'),
      onTap:() {},
    );
  }

  Widget _switchModeTile(BuildContext context, AppMode _mode){
    // return ListTile(
    //   title: Text('Currently in ${_mode.mode}, Press to Switch'),
    //   onTap:() {
    //     Navigator.pop(context);
    //     _mode.switchMode();}
    // );

    SvgPicture chefHat = SvgPicture.asset('assets/images/chef.svg', width: 20,);
    // SvgPicture.
    return Container(
      child: new InkWell(
        child: _mode.mode == Mode.Consumer ? Icon(Icons.local_dining) : chefHat,
        onTap: () {
          print("Mode clicked");
          Navigator.pop(context);
          _mode.switchMode();
        }
      ),
    );
  }
}