import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/routes/_router.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final FocusNode _emailFocus = FocusNode();
  bool isPressed;

  @override
  void initState() {
    isPressed = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: _auth.user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return profile(_auth, userData, context);
          }
          //Navigator.pop(context);
          //_auth.signOut();
          return Loading();
        });
  }

  Widget profile(AuthService _auth, UserData userData, BuildContext context) {
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: "Edit Profile"),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        header(userData),
        SizedBox(height: 20),
        //test(),
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                //profileEntry(userData),
                emailEntry(userData.email)
              ],
            )),
        //emailEntry(),
        Divider(),
        //profileEntry(),
        allergyButton(_auth, userData, context)

      ])),
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
                            Text(userData.displayName,
                                style: TextStyle(fontSize: 20)),
                            HumanatyRating(rating: userData.consumerRating)
                          ],
                        ),
                      ),
                      //PLACEHOLDER FOR PROFILE PICTURE
                      Container(
                          color: Pallete.humanGreenLight,
                          width: 100.0,
                          height: 100.0)
                    ],
                  ),
                )
              ],
            )));
  }

  Widget profileEntry(UserData userData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                cursorColor: Pallete.humanGreen,
                style: TextStyle(
                    //color: Colors.red
                    //backgroundColor: Colors.red,
                    //decorationColor: Colors.red
                    ),
                initialValue: userData.displayName,
                decoration: InputDecoration(
                    labelText: "First Name",
                    labelStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none),
              ),
            ),
            Expanded(
                child: TextFormField(
              decoration: InputDecoration(
                  hintText: "Last Name",
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          //color: Pallete.humanGreen
                          ))),
            ))
          ],
        ),
      ],
    );
  }

  Widget header(UserData userData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(width: 75, height: 75, child: Placeholder()),
        //SizedBox(width: 50),
        Container(
          height: 70,
          width: 150,
          child: Column(
            children: <Widget>[
              nameField(userData.displayName),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  HumanatyRating(rating: userData.consumerRating, starSize: 15)
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget nameField(String displayName) {
    return TextFormField(
      initialValue: displayName,
      style: TextStyle(fontSize: 20),
      textAlign: TextAlign.center,
      cursorColor: Pallete.humanGreenLight,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: -20),
          hintText: "Name",
          border: InputBorder.none),
    );
  }

  Widget emailEntry(String email) {
    return TextFormField(
      initialValue: email,
      style: TextStyle(fontSize: 16),
      focusNode: _emailFocus,
      cursorColor: Pallete.humanGreenLight,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(),
          labelText: "Email",
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          border: InputBorder.none),
    );
  }

  
  
  
  
  Widget birthDayEntry() {
    return TextFormField(
      focusNode: _emailFocus,
      cursorColor: Pallete.humanGreenLight,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 20),
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.black, fontSize: 40),
          border: InputBorder.none),
    );
  }

  Widget allergyButton(AuthService _auth, UserData userData, BuildContext context) {
    print(userData.allergies.runtimeType);
    return ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("Allergies"),
      onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => AllergyPage(userAllergies: userData.allergies, auth: _auth)),);},
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
                border: Border.all(color: Pallete.humanGreenLight)),
            width: sectionWidth,
            height: 80,
            child: Text(content),
          )
        ],
      ),
    );
  }
}
