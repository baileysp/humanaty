import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';

class EmailEdit extends StatefulWidget {
  final String email;
  EmailEdit({this.email});

  @override
  _EmailEditState createState() => _EmailEditState();
}

class _EmailEditState extends State<EmailEdit> {
  TextEditingController _emailController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _emailController = TextEditingController(text: widget.email);
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: HumanatyAppBar(
          displayCloseBtn: true,
          title: 'Update Email',
          actions: [_save(auth)],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(key: _formKey, child: _editEmail()),
        ));
  }

  Widget _editEmail() {
    return TextFormField(
      controller: _emailController,
      decoration: textInputDecoration,
      validator: emailValidator,
      inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
    );
  }

  Widget _save(AuthService auth) {
    return FlatButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            if (await auth.changeEmail(_emailController.text)) {
              Navigator.pop(context);
            }
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _alertDialog();
                });
          }
        },
        child: Text(
          'SAVE',
          style: TextStyle(color: Pallete.humanGreen),
        ));
  }

  AlertDialog _alertDialog() {
    return AlertDialog(
      title: Text('Something went wrong'),
      actions: <Widget>[
        FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(color: Pallete.humanGreen),
            ))
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
