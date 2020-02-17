import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';

class ResetDialog extends StatefulWidget {
  @override
  _ResetDialog createState() => _ResetDialog();
}

class _ResetDialog extends State<ResetDialog> {
  final _emailController = TextEditingController();

  final _forgotPasswordFormKey = GlobalKey<FormState>();
  String _errorMessage;
  bool _linkSent = false;

  @override
  void initState() {
    _errorMessage = "";
    _linkSent = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);

    return AlertDialog(
      title: Text("Forgot Password?"),
      content: SingleChildScrollView(
          child: Column(
        children: !_linkSent ? preLink(user) : postLink(user),
      )),
    );
  }

  List<Widget> preLink(user) {
    return [
      infoText(),
      SizedBox(height: 20),
      errorText(),
      emailField(),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[cancelButton(), resetButton(user)],
      )
    ];
  }

  List<Widget> postLink(user) {
    return [
      sentText(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[cancelButton()],
      )
    ];
  }

  Widget infoText() {
    return Text(
        "Enter your email address and we will send you a link to reset your password.");
  }

  Widget sentText() {
    return Text("Password reset link sent successfully.");
  }

  Widget errorText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(_errorMessage != null ? _errorMessage : "",
          style: TextStyle(color: Colors.red, fontSize: 13.0)),
    );
  }

  Widget emailField() {
    return Form(
      key: _forgotPasswordFormKey,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: textInputDecoration.copyWith(
            hintText: "Email",
            prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: emailValidator,
      ),
    );
  }

  Widget cancelButton() {
    return RaisedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text((_linkSent == false) ? "Cancel" : "Close",
            style: TextStyle(color: Colors.black, fontSize: 16.0)));
  }

  Widget resetButton(user) {
    return RaisedButton(
        onPressed: () async {
          if (_forgotPasswordFormKey.currentState.validate()) {
            String email = _emailController.text;
            if (!await user.sendPasswordResetEmail(email)) {
              setState(() {
                _errorMessage = user.error;
              });
            } else {
              setState(() {
                _errorMessage = "";
                _linkSent = true;
              });
            }
          }
        },
        color: Pallete.humanGreen,
        child: Text("Reset Password",
            style: TextStyle(color: Colors.white, fontSize: 16.0)));
  }
}
