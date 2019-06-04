import 'package:flash_chat/controlls/MenuButton.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/utils/Animations.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  String name = "Flash Chat";





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height:60,
                  ),
                ),
                Expanded(
                  child: TypewriterAnimatedTextKit(
                    text: [name],
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontFamily: 'fonts/Agnes-Regular.ttf',
                      fontSize: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MenuButton(title: 'Login',onPress: (){Navigator.pushNamed(context, LoginScreen.id);},buttonColors: kButtonsColor,),
            MenuButton(title: 'Register',onPress: (){Navigator.pushNamed(context, RegistrationScreen.id);},buttonColors: kButtonsColor,),
          ],
        ),
      ),
    );
  }
}





