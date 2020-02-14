import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/routes/_router.dart';

class Profile extends StatefulWidget {
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print("Profile called \n");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            title
          ]
        )
      ),
      // bottomNavigationBar: BottomNavBarRouter(),
    );

  }
}

Widget title = Container(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "HuMANAty Current Profile",
          style: TextStyle(fontSize: 34),
        ),
      ));