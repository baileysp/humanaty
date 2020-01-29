import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/common/widgets/constants.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  //final AuthService _auth = AuthService();
   
  final _registrationFormKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _passwordObscured;


  @override 
  void initState(){
    _passwordObscured = true;
    super.initState();
  }
  
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: backButton()
        ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Text("Join Our Community,",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30.0),
            ),
          Text("Create an account with humanaty", 
            style: TextStyle(fontSize: 16)),
          SizedBox(height: 50),
          Form(
            key: _registrationFormKey,
            child: Column(
              children: <Widget>[
                nameField(),
                emailField(),
                passwordField(),
                confirmPasswordField(),
                SizedBox(height: 30),
                registerButton(),
                SizedBox(height: 30),
                alreadyUser()

              ],
            )
          )
        ],
      )
    );
  }

  Widget backButton(){
    return IconButton(
      onPressed: (){Navigator.pop(context);},
      icon: Icon(
        Icons.arrow_back,
        color: Colors.grey
      )
    );
  }

  Widget nameField(){
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        decoration: textInputDecoration.copyWith(
          hintText: "Name",
          prefixIcon: Icon(Icons.person_outline, color: Colors.grey))
      ),
    );
  }

  Widget emailField(){
    return SizedBox(
      height: 70.0,
      child: TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: textInputDecoration.copyWith(
        hintText: "Email",
        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)),
      validator: emailValidator
      ),
    );
  }

  Widget passwordField(){
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        controller: _passwordController,
        obscureText: _passwordObscured,
        decoration: textInputDecoration.copyWith(
          hintText: "Password",
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
          suffixIcon: IconButton(
              icon: Icon(_passwordObscured ? Icons.visibility_off : Icons.visibility),
              color: Colors.grey,
              onPressed: () {
                setState(() {
                  _passwordObscured = !_passwordObscured;
                });
              },
            )),        
        validator: passwordValidator
      ),
    );
  }

  Widget confirmPasswordField(){
    return SizedBox(
      height: 70.0,
      child: TextFormField(
        obscureText: _passwordObscured,
        decoration: textInputDecoration.copyWith(
          hintText: "Confirm Password",
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey)),
        validator: (confirmation){
          String password = _passwordController.text;
          return confirmation == password ? null : "Passwords do not match";
        },
      ),
    );
  }

  Widget registerButton(){
    return Container(
      width: double.infinity,
      height: 50.0,
      child: FlatButton(
        color: Pallete.humanGreen,
        onPressed: () {
          if(_registrationFormKey.currentState.validate()){
            String password = _passwordController.text;
            String email = _emailController.text.trim();
                                  
          }
        } ,
        child: Text("Register", 
          style: TextStyle(color: Colors.white, fontSize: 16.0)
        )
      ),
    )
    ;
  }

  Widget alreadyUser() {
    return FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Already have an account? Login"));
  }
}



