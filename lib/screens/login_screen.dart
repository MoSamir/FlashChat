import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/controlls/MenuButton.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../constants.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
   static const id = 'LoginScreen';


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isNetworkActive = false;
  String userName,userPassword;
  final _auth = FirebaseAuth.instance;
  FirebaseUser currentUser ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isNetworkActive,
        progressIndicator: SpinKitFoldingCube(
          color: Colors.lightBlue,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      //Do something with the user input.
                      userName = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Username'
                    ),
                    style: kSendButtonTextStyle,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: true,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      userPassword = value ;

                      //Do something with the user input.
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Password'
                    ),
                    style: kSendButtonTextStyle,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  MenuButton(title: 'Login',onPress: onLoginClicked,buttonColors: kButtonsColor,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onLoginClicked(){

    setState(() {
      isNetworkActive = true ;
    });

    Future.delayed(const Duration(seconds: 4), ()async{
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: userName, password: userPassword);
        if (user != null) {
          currentUser = user;
          print("Auth Scuccessful ${user.email}");
          Navigator.pushNamed(context, ChatScreen.id);
        } else {
          print("Auth Returned Null");
        }
      } catch (e) {
        print('Exception Accured  $e ');
      } finally {
        setState(() {
          isNetworkActive = false;
        });
      }
    });
  }

}
