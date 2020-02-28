import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/util/validator.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  
  final _registrationFormKey = GlobalKey<FormState>();
  bool _passwordObscured;
  String _errorMessage;

  @override
  void initState() {
    _passwordObscured = true;
    _errorMessage = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: HumanatyAppBar(displayBackBtn: true),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Text('Join Our Community,',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),),
            Text("Create an account with huMANAty",
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 50),
            errorText(),
            Form(
              key: _registrationFormKey,
              child: Column(
                children: <Widget>[
                  nameField(),
                  emailField(),
                  passwordField(),
                  confirmPasswordField(),
                  SizedBox(height: 30),
                  registerButton(_auth),
                  SizedBox(height: 30),
                  alreadyUser()
                ],
              )
            )
          ],
        )
    );
  }

  Widget errorText() {
    return SizedBox(
      height: 20,
      child: Text(_errorMessage!= null ? _errorMessage : '',
        style: TextStyle(color: Colors.red, fontSize: 13.0)));
  }

  Widget nameField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _nameController,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocus,
          decoration: textInputDecoration.copyWith(
            hintText: 'Name',
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey)),
        onFieldSubmitted: (term) {_fieldFocusChange(context, _nameFocus, _emailFocus);}),
    );
  }

  Widget emailField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        decoration: textInputDecoration.copyWith(
          hintText: 'Email',
          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: emailValidator,
        onFieldSubmitted: (term) {_fieldFocusChange(context, _emailFocus, _passwordFocus);},),
    );
  }

  Widget passwordField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _passwordObscured,
        textInputAction: TextInputAction.next,
        focusNode: _passwordFocus,
        decoration: textInputDecoration.copyWith(
          hintText: 'Password',
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(_passwordObscured ? Icons.visibility_off : Icons.visibility),
            color: Colors.grey,
            onPressed:() {setState(() {_passwordObscured = !_passwordObscured;});},
          )),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: passwordValidator,
        onFieldSubmitted: _fieldFocusChange(context, _passwordFocus, _confirmPassFocus),),
    );
  }

  Widget confirmPasswordField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        obscureText: _passwordObscured,
        textInputAction: TextInputAction.done,
        focusNode: _confirmPassFocus,
        decoration: textInputDecoration.copyWith(
          hintText: 'Confirm Password',
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey)),
        inputFormatters: [BlacklistingTextInputFormatter(RegExp('[ ]'))],
        validator: (password) => confirmPassValidator(password, _passwordController)),
    );
  }

  Widget registerButton(AuthService user) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: RaisedButton(
        color: Pallete.humanGreen,
        onPressed: () async {
          if (_registrationFormKey.currentState.validate()) {
            String displayName = _nameController.text.trim();
            String email = _emailController.text;
            String password = _passwordController.text;              
            if (!await user.createUserWithEmailAndPassword(displayName, email, password)) {
              setState((){
                _errorMessage = user.error;
                _registrationFormKey.currentState.reset();
              });
            } else{Navigator.pop(context);}}
        },
        child: Text(user.status == Status.Authenticating ? 'Registering' : 'Register',
          style: TextStyle(color: Colors.white, fontSize: 16.0))),
    );
  }

  Widget alreadyUser() {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed:() => Navigator.pop(context),
      child: Text('Already have an account? Login'));
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }
}
