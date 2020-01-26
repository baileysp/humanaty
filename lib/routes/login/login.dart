import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _signInFormKey = GlobalKey<FormState>();
  bool _passwordObscured;

  @override 
  void initState(){
    _passwordObscured = true;
    super.initState();
    //pasword visibility false
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Container(
        child: loginForm()
      )
    );
  }

  Widget loginForm(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _signInFormKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            usernameField(),
            passwordField(),
            loginButton(),
            googleSignIn(),
            newUser()
          ],
        )
      )
    );
  }

  Widget usernameField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
         hintText: "Email"
        )
      )
    );
  }
  
  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        obscureText: _passwordObscured,
        decoration: InputDecoration(
          hintText: "Password",
          suffixIcon: IconButton(
            icon: Icon(_passwordObscured? Icons.visibility_off : Icons.visibility),
            onPressed:(){
              setState(() {
                _passwordObscured = !_passwordObscured;
              });
            },
          )
        )
      )
    );
  }

  Widget loginButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 35.0, 0, 0),
      child: FlatButton(
        color: Pallete.humanGreen,
        onPressed: (){
          setState(() {
            _passwordObscured = !_passwordObscured;
          });
        } ,
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white)
        )
      )
    );
  }

  Widget googleSignIn(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FlatButton(
        color: Pallete.humanGreenLight,
        onPressed: (){
          //move to forgot password page
        },
        child: Text(
          "Google Sign In",
          style: TextStyle(color: Colors.white)
        )
      )
    );
  }

  Widget newUser(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FlatButton(
        onPressed: (){
          Navigator.pushNamed(context, '/registration');
        },
        child: Text(
          "Don't have an account? Sign up"
        )
      )
    );
  }
  
  
  
  Widget forgotPassword(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FlatButton(
        onPressed: (){
          //move to forgot password page
        },
        child: Text(
          "Forgot Password?"
        )
      )
    );
  }






}