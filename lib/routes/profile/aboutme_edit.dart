import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/database.dart';

class AboutMeEdit extends StatefulWidget {
  final String aboutMe;
  AboutMeEdit({this.aboutMe});

  @override
  _AboutMeEditState createState() => _AboutMeEditState();
}

class _AboutMeEditState extends State<AboutMeEdit> {
  TextEditingController _aboutMeController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _aboutMeController = TextEditingController(text: widget.aboutMe);
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final database = DatabaseService(uid: auth.user.uid);

    return Scaffold(
        appBar: HumanatyAppBar(
          displayCloseBtn: true,
          title: 'Update About Me',
          actions: [_save(auth, database)],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(key: _formKey, child: _editAboutMe()),
        ));
  }

  Widget _editAboutMe() {
    return TextFormField(
      maxLines: 5,
      maxLength: 255,
      controller: _aboutMeController,
      decoration: textInputDecoration,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _save(AuthService auth, DatabaseService database) {
    return FlatButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            database.updateAboutMe(_aboutMeController.text);
            Navigator.pop(context);
          }
        },
        child: Text(
          'SAVE',
          style: TextStyle(color: Pallete.humanGreen),
        ));
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }
}
