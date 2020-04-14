import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  AuthService auth;
  DatabaseService database;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    database = DatabaseService(uid: auth.user.uid);
    SizeConfig().init(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: auth.user.uid).userData,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _profile(context, snapshot.data)
              : Loading();
        });
  }

  Widget _profile(BuildContext context, UserData userData) {
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: 'Edit Profile'),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            _header(userData.displayName, userData.photoUrl),
            _name(userData.displayName),
            Divider(),
            _email(userData.email),
            Divider(),
            _birthdayField(userData.birthday),
            Divider(),
            _aboutMe(userData.aboutMe),
            Divider(height: 40),
            _access(userData.accessibilityAccommodations),
            Divider(),
            _allergyBtn(userData.allergies)
          ]),
    );
  }

  Widget _header(String displayName, String photoUrl) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        ClipOval(
          child: Material(
            child: InkWell(
              onTap: () => showModalBottomSheet(context: context, builder: (_){return ImageOptions();},
                     backgroundColor: Colors.transparent),
              child: CircleAvatar(
                radius: 75,
                backgroundImage: NetworkImage(photoUrl),
                backgroundColor: Pallete.humanGreen54,
              ),
            ),
          ),
        ), 
      ],
    );
  }

  Widget _name(String name) {
    return InkWell(
      onTap: null,
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Name', style: TextStyle(color: Colors.black54)),
              Text('$name'),
            ],
          )),
    );
  }

  Widget _email(String email) {
    return InkWell(
      splashColor: Pallete.humanGreen54,
      onTap: () => Navigator.of(context)
          .pushNamed('/email_edit', arguments: {'email': email}),
      child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Email Address', style: TextStyle(color: Colors.black54)),
                  Text('$email'),
                ],
              ),
              _edit()  
            ],
          )),
    );
  }

  Widget _birthdayField(DateTime birthday) {
    DateFormat f = DateFormat.yMMMMd("en_US");
    return InkWell(
      splashColor: Pallete.humanGreen54,
      child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Birthday', style: TextStyle(color: Colors.black54)),
                  Text('${f.format(birthday)}'),
                ],
              ),
              _edit()
            ],
          )),
      onTap: () {
        DatePicker.showDatePicker(context,
            currentTime: birthday,
            onConfirm: database.updateUserBirthday,
            theme: DatePickerTheme(
                doneStyle: TextStyle(color: Pallete.humanGreen),
                itemStyle: TextStyle(color: Colors.black)));
      },
    );
  }

  Widget _aboutMe(String aboutMe) {
    return InkWell(
      splashColor: Pallete.humanGreen54,
      onTap: () => Navigator.of(context)
          .pushNamed('/aboutMe_edit', arguments: {'aboutMe': aboutMe}),
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('AboutMe', style: TextStyle(color: Colors.black54)),
              Text('$aboutMe'),
            ],
          )),
    );
  }

  Widget _access(bool access) {
    return InkWell(
      onTap: () => database.updateAccessibility(!access),
      child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Accessibility Accomodations Required',
                  style: TextStyle(color: Colors.black54)),
              Icon(access ? Icons.accessible_forward : Icons.accessibility,
                  color: access ? Pallete.humanGreen : Colors.black45),
            ],
          )),
    );
  }

  Widget _allergyBtn(Map<String, bool> allergies) {
    return InkWell(
      onTap: () => Navigator.of(context)
          .pushNamed('/allergy_edit', arguments: {'allergyMap': allergies}),
      child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Allergies', style: TextStyle(color: Colors.black54)),
                  Text('${Allergy().formattedStringFromMap(allergies)}'),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 20)
            ],
          )),
    );
  }

  Widget _edit(){
    return InkWell(
      onTap: null,
      splashColor: Pallete.humanGreen54,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Pallete.humanGreen)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: Text('EDIT', style: TextStyle(color: Pallete.humanGreen),))));  
  }

}
