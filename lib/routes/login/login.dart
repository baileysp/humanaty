import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final _signInFormKey = new GlobalKey<FormState>();
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
        child:loginForm()
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
            loginButton()
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
        color: Colors.lightGreen,
        
        child: Text(
          "Login"
        )
      )
    );
  }




}