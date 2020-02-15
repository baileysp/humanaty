import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/routes/_router.dart';

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
  return Scaffold(
    drawer: HumanatyDrawer(),
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          title(userData, context),
          titledSection("Ratings:"),
          titledSection("About Me:"),
          titledSection("Past Meals:"),
          titledSection("Allergies")
        ]
      )
    ),
    // bottomNavigationBar: BottomNavBarRouter(),
  );
}

Widget title(UserData userData, BuildContext context) { 
  return Container(
    padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 65,
                child: RaisedButton(
                  child: Text("Back"),
                  onPressed: () {
                    Navigator.pop(context);
                  }
                )
              ),
              Text(
                "HuMANAty Profile",
                style: TextStyle(fontSize: 24)
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        userData.displayName,
                        style: TextStyle(fontSize: 20)
                      ),
                      HumanatyRating(rating: userData.consumerRating)
                    ],
                  ),
                ),
                //PLACEHOLDER FOR PROFILE PICTURE
                Container(
                  color: Pallete.humanGreenLight,
                  width: 100.0,
                  height: 100.0
                )
              ],
            ),
          )
        ],
      )
    )
  );
}

Widget titledSection(String text) {
  return Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            text,
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Pallete.humanGreenLight
            )
          ),
          width: 300,
          height: 80,
        )
      ],
    ),
  );
}