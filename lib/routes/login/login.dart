import 'package:flutter/material.dart';
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
    //pasword visibility false
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: Container(
        color: Colors.white,
        child: loginForm()
      )
    );
  }

  Widget loginForm(){
    return Padding(
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
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: textInputDecoration.copyWith(
          hintText: "Username",
          prefixIcon: Icon(Icons.mail_outline, color: Colors.grey)
        ),
        validator: emailValidator,
      )
    );
  }
  
  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: TextFormField(
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
      )
    );
  }

  Widget loginButton(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 35.0, 0, 0),
      child: FlatButton(
        color: Pallete.humanGreen,
        onPressed: (){
          String password = _passwordController.text;
            String email = _emailController.text.trim();
            dynamic result = _auth.registerWithEmailAndPassword(email, password);               
            if(result != null){
              Navigator.pushReplacementNamed(context, '/home');
            }
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

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.nfc),
            Text("Sign in with Google")


          ],
        ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(0.0),
              side: BorderSide(color: Colors.blue),
          ),
        onPressed: (){
          _auth.signinwithGoogle();
        }
      )
    );
  }

  Widget newUser(){
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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