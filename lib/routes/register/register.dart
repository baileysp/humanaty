import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/services/auth.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final AuthService _auth = AuthService();
  
  
  final _registrationFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
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
        child: registrationForm()
      )
    );
  }

  Widget registrationForm(){
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _registrationFormKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            nameField(),
            emailField(),
            passwordField(),
            confirmPasswordField(),
            registerButton()
            
          ],
        )
      )
    );
  }

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
         decoration: InputDecoration(
         hintText: "Full Name"
        )
      )
    );
  }

  Widget emailField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
      child: TextFormField(
        controller: _emailController,
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
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
        ),
        validator: (password){
          var result = password.length < 9 ? "Password should be at least 8 characters" : null;
          return result;
        }
      )
    );
  }

  Widget confirmPasswordField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
        obscureText: _passwordObscured,
        decoration: InputDecoration(
          hintText: "Confirm Password",
        ),
        validator: (confirmation){
          String password = _passwordController.text;
          return confirmation == password ? null : "Passwords do not match";
        },
      )
    );
  }

  Widget registerButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 35.0, 0, 0),
      child: FlatButton(
        color: Pallete.humanGreen,
        onPressed: () async {
          if(_registrationFormKey.currentState.validate()){
            String password = _passwordController.text;
            String email = _emailController.text;
            _auth.registerWithEmailAndPassword(email.trim(), password);                
            //Navigator.pushNamed(context, '/registration');
          }
        } ,
        child: Text(
          "Register",
          style: TextStyle(color: Colors.white)
        )
      )
    );
  }







}
