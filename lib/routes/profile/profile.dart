import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  const Profile({Key key, this.userData}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _aboutMeController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final _updateProfileFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    return profile(context, _auth, widget.userData);
  }

  Widget profile(BuildContext context, AuthService _auth, UserData userData) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: HumanatyAppBar(
          displayBackBtn: true,
          title: "Edit Profile",
          actions: [updateProfileAppBar(context, _auth, userData)]),
      //resizeToAvoidBottomInset: false,
      body: ListView(
          children: <Widget> [
            Form(
            key: _updateProfileFormKey,
            child: Column(children: <Widget>[
              header(userData),
              emailField(userData),
              birthdayField(context, userData),
            ])),
            aboutMeField(userData,),
            SizedBox(height: 20),
            wheelChairAccessiblity(userData),
            allergyButton(context, _auth, userData),
            SizedBox(height: 16),
            updateProfile(context, _auth, userData),
            SizedBox(height: 32)
          ]          
        ),
    );
  }

  Widget header(UserData userData) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width: 150, height: 125, 
            child: Stack(
              alignment: Alignment.bottomRight,
              //crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, bottom: 16),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData.photoUrl),
                      backgroundColor: Pallete.humanGreen,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed:()async {
                      await showModalBottomSheet(context: context, builder: (context){ return ImageOptions();
                      },backgroundColor: Colors.transparent);
                      setState((){var test = 5;});},
                  )
              ],
            )),
          Container(
            height: 100,
            width: 200,
            child: Column(
              children: <Widget>[
                SizedBox(height: 16),
                nameField(userData),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    HumanatyRating(
                        rating: userData.consumerRating, starSize: 15)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget nameField(UserData userData) {
    _nameController.text = userData.displayName;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
            width: 150,
            child: TextFormField(
                controller: _nameController,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(),
                    border: InputBorder.none),
                validator: nameValidator))
      ],
    );
  }

  Widget emailField(UserData userData) {
    _emailController.text = userData.email;
    return ListTile(
      title: Text("Email"),
      trailing: SizedBox(
        width: 200,
        child: TextFormField(
          controller: _emailController,
          focusNode: _emailFocus,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(),
            border: InputBorder.none,
          ),
          inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
          validator: emailValidator,
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
    );
  }

  Widget aboutMeField(UserData userData) {
    _aboutMeController.text = userData.aboutMe;
    return Column(
      children: <Widget>[
        ListTile(title: Text("About Me"),),
        SizedBox(
          width: 350,
          child: TextFormField(
            maxLines: 3,
            maxLength: 255,
            controller: _aboutMeController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            decoration: textInputDecoration
          )
        )
      ],
    );
  }

  Widget birthdayField(BuildContext context, UserData userData) {
    return ListTile(
        title: Text("Birthday"),
        trailing: Icon(Icons.cake),
        onTap: () {
          DatePicker.showDatePicker(context, currentTime: userData.birthday,
              onConfirm: (date) {
            userData.birthday = date;
          },
              theme: DatePickerTheme(
                  doneStyle: TextStyle(color: Pallete.humanGreen)));
        });
  }

  Widget wheelChairAccessiblity(UserData userData) {
    return ListTile(
      trailing: Icon(
          userData.accessibilityAccommodations
              ? Icons.accessible_forward
              : Icons.accessibility,
          color: userData.accessibilityAccommodations
              ? Pallete.humanGreen
              : Colors.black45),
      title: Text("Accessibility Accomodation Required"),
      onTap: () {
        setState(() {
          userData.accessibilityAccommodations =
              !userData.accessibilityAccommodations;
        });
      },
    );
  }

  Widget allergyButton(BuildContext context, AuthService _auth, UserData userData) {
    return ListTile(
      trailing: Icon(Icons.arrow_forward),
      title: Text("Allergies"),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AllergyPage(userAllergies: userData.allergies, auth: _auth)),
        );
      },
    );
  }

  Widget updateProfile(BuildContext context, AuthService _auth, UserData userData) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Container(
        width: double.infinity,
        height: 50.0,
        child: RaisedButton(
            color: Pallete.humanGreen,
            onPressed: () async {
              updateProfileFunc(context, _auth, userData);
            },
            child: Text("Update Profile",
                style: TextStyle(color: Colors.white, fontSize: 16.0))),
      ),
    );
  }

  Widget updateProfileAppBar(BuildContext context, AuthService _auth, UserData userData) {
    return FlatButton(
        onPressed: () async {
          updateProfileFunc(context, _auth, userData);
        },
        child: Text(
          "update",
          style: TextStyle(color: Colors.black87),
        ));
  }

  void updateProfileFunc(BuildContext context, AuthService _auth, UserData userData) async {
    if (_updateProfileFormKey.currentState.validate()) {
      String displayName = _nameController.text.trim();
      String email = _emailController.text;
      String aboutMe = _aboutMeController.text;
      userData.displayName = displayName;
      //userData.email = email;
      userData.aboutMe = aboutMe;

      await DatabaseService(uid: _auth.user.uid).updateUserData(userData);
    }
  }

}
