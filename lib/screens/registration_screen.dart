import 'package:flash_chat/controlls/MenuButton.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String userName, userPassword;
  bool backgroundActivity = false;
  bool isError = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: backgroundActivity,
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
                    style: kSendButtonTextStyle,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      //Do something with the user input.
                      userName = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your username'),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    style: kSendButtonTextStyle,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      userPassword = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password'),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  MenuButton(
                    title: 'Register',
                    onPress: onRegisterPressed,
                    buttonColors: kButtonsColor,
                  ),
                Visibility(
                  visible: isError,
                  child: Text('Invalid username or password', textAlign: TextAlign.center,style: TextStyle(
                    color: Colors.red,
                    fontSize: 15,
                  ),),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  onRegisterPressed() {
    setState(() {
      backgroundActivity = true;
    });

    Future.delayed(const Duration(seconds: 4), () async {
      try {
        final userData = await _auth.createUserWithEmailAndPassword(
            email: userName, password: userPassword);

        if (userData != null) {
          isError = false ;
          Navigator.pushNamed(context, ChatScreen.id);
        }
      } catch (exception) {
        print(exception.toString());
        isError = true ;
      } finally {
        setState(() {
          backgroundActivity = false;
        });
      }
    });
  }
}
