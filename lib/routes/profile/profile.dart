import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/models/user.dart';

class Profile extends StatefulWidget {

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: _auth.user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData || _auth.status == Status.Anon) {
          UserData userData = snapshot.data;
          return profile(_auth, userData, context);
        }
        //Navigator.pop(context);
        //_auth.signOut();
        return Loading();
      });
  }
}

Widget profile(AuthService _auth, UserData userData, BuildContext context) {
  print(userData.displayName);
  return Scaffold(
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          title(userData)
        ]
      )
    ),
    // bottomNavigationBar: BottomNavBarRouter(),
  );
}

Widget title(UserData userData) { 
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Text(
            "HuMANAty Current Profile",
            style: TextStyle(fontSize: 20)
          ),
          Text(
            userData.displayName,
            style: TextStyle(fontSize: 16)
          ),
        ],
      )
    )
  );
}