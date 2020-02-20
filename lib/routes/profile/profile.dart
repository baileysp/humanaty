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
    appBar: HumanatyAppBar(displayBackBtn: true, title: "Profile"),
    drawer: HumanatyDrawer(),
    resizeToAvoidBottomInset: false,
    body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          title(userData, context),
          profileEntry(),
          Divider(),
          //profileEntry(),
          //titledSection("Ratings:", userData.aboutMe),
          //titledSection("About Me:", userData.aboutMe),
          //titledSection("Past Meals:", userData.aboutMe),
          //titledSection("Allergies:", userData.aboutMe),
        ]
      )
    ),
    // bottomNavigationBar: BottomNavBarRouter(),
  );
}

Widget title(UserData userData, BuildContext context) { 
  return Container(
    child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
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

Widget profileEntry(){
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                
                decoration: InputDecoration(
                  //filled: true,
                  hintText: "First Name",
                  border: InputBorder.none
                ),
              ),
            ), 
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  //filled: true,
                  hintText: "Last Name",
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      //color: Pallete.humanGreen
                    )
                  )
                ),
              )
            )
          ],
        ),
      ],
    ),
  );
}

Widget titledSection(String sectionTitle, String content) {
  double sectionWidth = 300;

  return Container(
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: sectionWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                sectionTitle,
                style: TextStyle(fontSize: 20),
              ),
              InkWell(
                child: Icon(Icons.edit),
                onTap: () {
                  print("Edit " + sectionTitle + " clicked");
                },
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Pallete.humanGreenLight
            )
          ),
          width: sectionWidth,
          height: 80,
          child: Text(content),
        )
      ],
    ),
  );
}