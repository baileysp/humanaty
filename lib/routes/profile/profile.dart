import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:humanaty/util/validator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutMeController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final _updateProfileFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool error = false;

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
      key: _scaffoldKey,
      appBar: HumanatyAppBar(displayBackBtn: true, title: 'Edit Profile'),
      body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            _header1(userData.displayName, userData.photoUrl),
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

  Widget _header1(String displayName, String photoUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 75,
          backgroundImage: NetworkImage(photoUrl),
          backgroundColor: Pallete.humanGreen,
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
      onTap: () =>
          Navigator.of(context).pushNamed('/email_edit', arguments: {'email': email}),
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Email Address', style: TextStyle(color: Colors.black54)),
              Text('$email'),
            ],
          )),
    );
  }

  Widget _birthdayField(DateTime birthday) {
    DateFormat f = DateFormat.yMMMMd("en_US");
    return InkWell(
      child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Birthday', style: TextStyle(color: Colors.black54)),
              Text('${f.format(birthday)}'),
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
      onTap: () => Navigator.of(context).pushNamed('/aboutMe_edit', arguments: {'aboutMe': aboutMe}),
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

  Widget _allergyBtn(Map<String, bool> allergies){
    return InkWell(
      onTap:() => Navigator.of(context).pushNamed('/allergy_edit', arguments: {'allergyMap' : allergies}),
      child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Allergies', style: TextStyle(color: Colors.black54)),
                  Text('${Allergy().formattedString(allergies)}'),
                ],
              ),
              Icon(Icons.arrow_forward_ios, size: 20)
            ],
          )),
    );
  }
}
