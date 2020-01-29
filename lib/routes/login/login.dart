import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets/constants.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _password = TextEditingController();
  final _email = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();
  bool _passwordObscured;

  @override
  void initState() {
    _passwordObscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    return Scaffold(
      body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            SizedBox(height: 80),
            Text("Welcome Back,",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
            ),
            Text("Sign in with humanaty",
              style: TextStyle(fontSize: 16)),
            SizedBox(height: 50),
            Form(
              key: _signInFormKey,
              child: Column(
                children: <Widget>[
                  usernameField(),
                  SizedBox(height: 0),
                  passwordField(),
                  SizedBox(height: 0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[forgotPassword()],
                    ),
                  SizedBox(height: 80.0),
                  user.status == Status.Authenticating ? Center(child: CircularProgressIndicator()) : loginButton(user),
                  SizedBox(height: 16.0),
                  googleSignIn(),
                  SizedBox(height: 40.0),
                  newUser()
                ],
              )
            )
          ]
      ),
    );
  }

  Widget usernameField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: textInputDecoration.copyWith(
            hintText: "Email",
            prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
        validator: emailValidator,
      ),
    );
  }

  Widget passwordField() {
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _password,
        obscureText: _passwordObscured,
        decoration: textInputDecoration.copyWith(
            hintText: "Password",
            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(
                  _passwordObscured ? Icons.visibility_off : Icons.visibility),
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  _passwordObscured = !_passwordObscured;
                });
              },
            )),
        validator: passwordValidator,
      ),
    );
  }

  Widget loginButton(AuthService user) {
    return Container(
      width: double.infinity,
      height: 50.0,
      child: FlatButton(
          color: Pallete.humanGreen,
          onPressed: () async {
            if (_signInFormKey.currentState.validate()) {
              String email = _email.text.trim();
              String password = _password.text;
                           
              if(!await user.signInWithEmailAndPassword(email, password)){
                print("something went wrong");
              }
            }
          },
          child: Text("Login",
              style: TextStyle(color: Colors.white, fontSize: 16.0))),
    );
  }

  Widget googleSignIn() {
    return Container(
      height: 50.0,
      child: OutlineButton(
          onPressed: () {},
          borderSide: BorderSide(width: 2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Sign in with Google", style: TextStyle(fontSize: 16.0))
            ],
          )),
    );
  }

  Widget newUser() {
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.pushNamed(context, '/registration');
        },
        child: Text("Don't have an account? Sign up"));
  }

  Widget forgotPassword() {
    return InkWell(
        onTap: () {
          _showForgotPasswordDialog();
        },
        child: Text("Forgot Password?"));
  }

  void _showForgotPasswordDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Reset Password"),
            content: SingleChildScrollView(              
              child: Column(
                children: <Widget>[
                  Text("Enter your email address and we will send you a link to reset your password."),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Email",
                        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
                    validator: emailValidator,
                  ),
                ],
              )
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel",
                style: TextStyle(color: Colors.black, fontSize: 16.0)),
                onPressed: () {Navigator.of(context).pop();}),
              SizedBox(width: 20),
              FlatButton(
              color: Pallete.humanGreen,
              onPressed: () {},
              child: Text("Reset Password",
                  style: TextStyle(color: Colors.white, fontSize: 16.0))),
              SizedBox(width: 8)
            ],
          );
        });
  }
}
