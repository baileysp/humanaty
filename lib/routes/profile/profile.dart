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

  bool _accessibilityAccommodations;
  DateTime _birthday;
  bool error = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: auth.user.uid).userData,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? _profile(context, auth, snapshot.data)
              : Loading();
        });
  }

  Widget _profile(BuildContext context, AuthService auth, UserData userData) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HumanatyAppBar(
          displayBackBtn: true,
          title: 'Edit Profile',
          actions: [_updateProfileAppBar(context, auth, userData)]),
      body: ListView(children: <Widget>[
        Form(
            key: _updateProfileFormKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: <Widget>[
                _header1(userData.displayName, userData.photoUrl),
                _name(),
                Divider(),
                _email()
                //_header(userData.displayName, userData.photoUrl),
                //_emailField(userData),
                //_birthdayField(context, _birthday ?? userData.birthday),
              ]),
            )),
        //_aboutMeField(userData.aboutMe),
        SizedBox(height: 20),
        //_accessiblityAccomodations(_accessibilityAccommodations ??
        //userData.accessibilityAccommodations),
        //_allergyBtn(context, auth, userData.allergies),
        SizedBox(height: 16),
        //_updateProfile(context, auth, userData),
        SizedBox(height: 32)
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

  Widget _name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Name',
          style: TextStyle(color: Colors.black54),
        ),
        SizedBox(
          height: 40,
          child: TextFormField(
            
            cursorColor: Pallete.humanGreen,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedErrorBorder: errorBorderOutline,
              errorBorder: errorBorderOutline,
              contentPadding: EdgeInsets.only(top: -20),
            ),
            autovalidate: true,
            validator: notEmpty,
          ),
        )
      ],
    );
  }

  Widget _email() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email',
          style: TextStyle(color: Colors.black54),
        ),
        InkWell(
          onTap: (){},
          child: SizedBox(
            width: double.infinity,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('bailey.spencer00')
            )
          ),
        )
        
        
      ],
    );
  }

  Widget _header(String displayName, String photoUrl) {
    return Padding(
      padding: EdgeInsets.only(right: 16, left: 16),
      child: Row(
        //mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomRight,
            //crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0, bottom: 16),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Pallete.humanGreen,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ImageOptions();
                      },
                      backgroundColor: Colors.transparent);
                },
              )
            ],
          ),
          Container(
            height: 100,
            width: 200,
            child: Column(
              children: <Widget>[SizedBox(height: 16), _nameField(displayName)],
            ),
          )
        ],
      ),
    );
  }

  Widget _nameField(String displayName) {
    _nameController.text = displayName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            width: 150,
            child: TextFormField(
                controller: _nameController,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                decoration: InputDecoration(border: InputBorder.none),
                validator: nameValidator))
      ],
    );
  }

  Widget _emailField(UserData userData) {
    _emailController.text = userData.email;
    return ListTile(
        title: Text('Email'),
        trailing: SizedBox(
          width: 250,
          child: TextFormField(
            controller: _emailController,
            focusNode: _emailFocus,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
            validator: emailValidator,
          ),
        ),
        onTap: () => FocusScope.of(context).requestFocus(_emailFocus));
  }

  Widget _aboutMeField(String aboutMe) {
    _aboutMeController.text = aboutMe;
    return Column(
      children: <Widget>[
        ListTile(
          title: Text('About Me'),
        ),
        SizedBox(
            width: 350,
            child: TextFormField(
                maxLines: 3,
                maxLength: 255,
                controller: _aboutMeController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.done,
                decoration: textInputDecoration))
      ],
    );
  }

  Widget _birthdayField(BuildContext context, DateTime birthday) {
    DateFormat f = DateFormat.yMMMMd("en_US");
    return ListTile(
        title: Text('Birthday'),
        trailing:
            Text('${f.format(birthday)}', style: TextStyle(fontSize: 15.0)),
        onTap: () {
          DatePicker.showDatePicker(context,
              currentTime: birthday,
              onConfirm: (date) => {_birthday = date},
              theme: DatePickerTheme(
                  doneStyle: TextStyle(color: Pallete.humanGreen),
                  itemStyle: TextStyle(color: Pallete.humanGreen)));
        });
  }

  Widget _accessiblityAccomodations(bool accessibilityAccommodations) {
    return ListTile(
      trailing: Icon(
          accessibilityAccommodations
              ? Icons.accessible_forward
              : Icons.accessibility,
          color: accessibilityAccommodations
              ? Pallete.humanGreen
              : Colors.black45),
      title: Text('Accessibility Accomodation Required'),
      onTap: () {
        setState(() {
          _accessibilityAccommodations =
              _accessibilityAccommodations ?? accessibilityAccommodations;
          _accessibilityAccommodations = !_accessibilityAccommodations;
        });
      },
    );
  }

  Widget _allergyBtn(
      BuildContext context, AuthService _auth, Map<String, bool> allergies) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text('Allergies'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AllergyEdit(userAllergies: allergies, auth: _auth)),
        );
      },
    );
  }

  Widget _updateProfile(
      BuildContext context, AuthService _auth, UserData userData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: RaisedButton(
            color: Pallete.humanGreen,
            onPressed: () async => _updateProfileFunc(context, _auth, userData),
            child: Text('Update Profile',
                style: TextStyle(color: Colors.white, fontSize: 16.0))),
      ),
    );
  }

  Widget _updateProfileAppBar(
      BuildContext context, AuthService _auth, UserData userData) {
    return FlatButton(
        onPressed: () async {
          Navigator.pop(context);
          _updateProfileFunc(context, _auth, userData);
        },
        child: Text(
          'update',
          style: TextStyle(color: Colors.black87),
        ));
  }

  void _updateProfileFunc(
      BuildContext context, AuthService _auth, UserData userData) async {
    if (_updateProfileFormKey.currentState.validate()) {
      String _aboutMe = _aboutMeController.text.trim();
      _accessibilityAccommodations ??= userData.accessibilityAccommodations;
      _birthday ??= userData.birthday;
      String _displayName = _nameController.text;
      //String email = _emailController.text;
      await DatabaseService(uid: _auth.user.uid).updateUserData(
          _aboutMe, _accessibilityAccommodations, _birthday, _displayName);
    }
  }
}
