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
  final UserData userData;
  const Profile({Key key, this.userData}): super(key: key);

  @override
  ProfileState createState() => ProfileState();
  
}

class ProfileState extends State<Profile> {
  final FocusNode _emailFocus = FocusNode();
  //bool _accessibilityAccommodations;

  @override
  void initState() {
    //_accessibilityAccommodations = ;
    //this.userData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    return profile(_auth, widget.userData, context);
    // return StreamBuilder<UserData>(
    //     stream: DatabaseService(uid: _auth.user.uid).userData,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         UserData userData = snapshot.data;
    //         return profile(_auth, userData, context);
    //       }
    //       Navigator.pop(context);
    //       _auth.signOut();
    //       return Loading();
    //     });
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
                  //emailEntry(userData.email),
                  Divider(),
                  emailEdit(userData.email),
                ],
              )),
          //emailEntry(),
          Divider(),
          //profileEntry(),
          wheelChairAccessiblity(userData),
          allergyButton( context, _auth, userData),
          updateProfile(_auth, userData)
      ])),
    );
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

  Widget emailEdit(String email){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("Email", style: TextStyle(fontSize: 16),),
        SizedBox(
          width: 300,
          child: TextFormField(
            textAlign: TextAlign.right,
            initialValue: email,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(),
              border: InputBorder.none
            ),
          ),
        )
      ],
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


  Widget wheelChairAccessiblity(UserData userData){
    return ListTile(
      trailing: Icon(userData.accessibilityAccommodations ? Icons.accessible_forward : Icons.accessibility,
                    color: userData.accessibilityAccommodations ? Pallete.humanGreen : Colors.black45),
      title: Text("Accessibility Accomodation Required"),
      onTap: (){setState(() {
        userData.accessibilityAccommodations = !userData.accessibilityAccommodations;
      });},
    );
  }

  Widget allergyButton( BuildContext context, AuthService _auth, UserData userData) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("Allergies"),
      onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => AllergyPage(userAllergies: userData.allergies, auth: _auth)),);},
    );
  }

  Widget updateProfile(AuthService _auth, UserData userData){
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: RaisedButton(
            color: Pallete.humanGreen,
            onPressed: () async {await DatabaseService(uid: _auth.user.uid).updateUserData(userData);},
            child: Text(
                "Update Profile",
                style: TextStyle(color: Colors.white, fontSize: 16.0))),
      ),
    );
  }
}

 
