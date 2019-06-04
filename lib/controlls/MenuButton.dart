import 'package:flash_chat/utils/Animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MenuButton extends StatefulWidget {



  MenuButton({@required this.title,@required this.onPress, @required this.buttonColors});
  String title ;
  Function onPress;
  ColorSwatch buttonColors ;

  ColorSwatch get btnColors => buttonColors;
  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> with SingleTickerProviderStateMixin{

  AnimationController _animationController ;
  Animation borderAnimation ;
  ColorSwatch usedColors ;

  getAnimation(){
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 2));
    _animationController.forward();
    _animationController.addListener((){
      setState(() {
      });
    });
    _animationController.addStatusListener((statues){
      if(statues == AnimationStatus.completed){
        _animationController.reverse(from: 1.0);
      } else if(statues == AnimationStatus.dismissed){
        _animationController.forward();
      }
    });
    borderAnimation = AnimationUtils.getTwinAnim(usedColors['animStart'],usedColors['animEnd'], _animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    usedColors = widget.buttonColors;
    getAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
                color: borderAnimation.value,
                width: 3
            )
        ),
        elevation: 5.0,
        color: usedColors['main'],

        child: MaterialButton(
          color: usedColors['main'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: widget.onPress,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}