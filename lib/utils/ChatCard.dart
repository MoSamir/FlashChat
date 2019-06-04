import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {

  bool isFromMe = true ;
  String message ;
  String email ;
  ChatCard({@required this.message , @required this.isFromMe , @required this.email});

  @override
  Widget build(BuildContext context) {
    Color cardColor = (isFromMe)? Colors.lightBlue : Colors.blue[700] ;
    CrossAxisAlignment alignment = (isFromMe)? CrossAxisAlignment.end :CrossAxisAlignment.start;

    BorderRadius fromMeBorderRad = BorderRadius.only(
      topRight: Radius.circular(0), topLeft: Radius.circular(30),
      bottomLeft: Radius.circular(30) , bottomRight: Radius.circular(30)
    );

    BorderRadius notFromMeBorderRad = BorderRadius.only(
        topRight: Radius.circular(30), topLeft: Radius.circular(0),
        bottomLeft: Radius.circular(30) , bottomRight: Radius.circular(30)
    );

    BorderRadius cardBorderRad = (isFromMe) ? fromMeBorderRad : notFromMeBorderRad;


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: alignment,
        children: <Widget>[
          Text(email,style: TextStyle(
        color: Colors.black54,
      ),),
          Card(
            shape : RoundedRectangleBorder(
              borderRadius: cardBorderRad,
            ),
            elevation: 8,
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0,horizontal: 20),
              child: Text(message, style: TextStyle(
                color: Colors.white,
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
