import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/size_config.dart';
import 'package:humanaty/util/validator.dart';


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
    final auth = Provider.of<AuthService>(context);
    SizeConfig().init(context);

    return AlertDialog(
      title: Text('Forgot Password?'),
      content: SingleChildScrollView(
        child: Column(
          children: !_linkSent ? _preLink(auth) : _postLink(auth),
      )),
    );
  }

  List<Widget> _preLink(user) {
    return[
      _infoText(),
      SizedBox(height: SizeConfig.screenHeight * .035),
      _errorText(),
      _emailField(),
      SizedBox(height: SizeConfig.screenHeight * .035),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_cancelButton(), _resetButton(user)],
      )
    ];
  }

  List<Widget> _postLink(user) {
    return [
      _sentText(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[_cancelButton()],
      )
    ];
  }

  Widget _infoText() => Text('Enter your email address and we will send you a link to reset your password.');
  
  Widget _sentText() => Text('Password reset link sent successfully.');
  
  Widget _errorText() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(_errorMessage != null ? _errorMessage : '',
          style: TextStyle(color: Colors.red, fontSize: 13.0)),
    );
  }

  Widget _emailField() {
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

  Widget _cancelButton() {
    return RaisedButton(
      onPressed:() => Navigator.of(context).pop(),      
      child: Text((_linkSent == false) ? 'Cancel' : 'Close',
        style: TextStyle(color: Colors.black, fontSize: 16.0)));
  }

  Widget _resetButton(user) {
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
        child: Text('Reset Password',
          style: TextStyle(color: Colors.white, fontSize: 16.0)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

}