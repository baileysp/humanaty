import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets/constants.dart';
import 'package:humanaty/services/auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final AuthService _auth = AuthService();
  
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  
  final _signInFormKey = GlobalKey<FormState>();
  bool _passwordObscured;

  @override 
  void initState(){
    _passwordObscured = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xFF408D78)));
    
    
    return new Scaffold(
      body: Container(
         
      )
    );
  }

  Widget usernameField(){
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: textInputDecoration.copyWith(
        hintText: "Username",
        prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)
      ),
      validator: emailValidator,
    );
  }
  
  Widget passwordField(){
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordObscured,
      decoration: textInputDecoration.copyWith(
        hintText: "Password",
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(_passwordObscured? Icons.visibility_off : Icons.visibility),
          color: Colors.grey,
          onPressed:(){
            setState(() {
              _passwordObscured = !_passwordObscured;
            });
          },
        )
      ),
      validator: passwordValidator,
    );
  }

  Widget loginButton(){
    return FlatButton(
      color: Pallete.humanGreen,
      onPressed: () async {
        if(_signInFormKey.currentState.validate()){
          String password = _passwordController.text;
          String email = _emailController.text.trim();
        }  
      } ,
      child: Text(
        "Login",
        style: TextStyle(color: Colors.white)

      )
    );
  }
  
  Widget googleSignIn(){
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.nfc),
          Text("Sign in with Google")
        ],
      ),
      onPressed: (){
        _auth.signInWithGoogle().whenComplete((){
            if (_auth.currentUser != null){
              Navigator.pushReplacementNamed(context, '/home');
            }else{
              _signInFormKey.currentState.reset();
            } 
          });             
      }
    );
  }

  Widget newUser(){
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: (){
        Navigator.pushNamed(context, '/registration');
      },
      child: Text(
        "Don't have an account? Sign up"
      )
    );
  }
    
  Widget forgotPassword(){
    return FlatButton(
      onPressed: (){
        //move to forgot password page
      },
      child: Text(
        "Forgot Password?"
      )
    );
  }
}