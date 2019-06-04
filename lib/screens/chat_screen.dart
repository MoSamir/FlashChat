import 'package:flash_chat/utils/ChatCard.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ChatScreen extends StatefulWidget {


  static const id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final myController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser ;
  String userMessage ;
  final _store = Firestore.instance;

  getCurrentUser()async {
    try {
      final user = await _auth.currentUser();
      if(user != null){
        loggedInUser = user;
      }
    } catch(exception){
      print(exception);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();

    if(loggedInUser!=null){
      print(loggedInUser.email);
    } else {
      print("Error Accured");
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  //Implement logout functionality
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️Chat'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: _store.collection('messages').snapshots(),
            builder: (context,snapShot){

              bool isMyMessage  = false ;

              if(snapShot.hasData) {
                List<ChatCard> messagesList = [];
                for(var message in snapShot.data.documents.reversed){
                  String messageText = message['text'];
                  String messageSender = message['sender'];

                  isMyMessage = messageSender == loggedInUser.email;
                  messagesList.add(ChatCard(
                    email: messageSender,
                    message: messageText,
                    isFromMe: isMyMessage,
                  ));
                }
                return Column(
                  mainAxisAlignment: isMyMessage? MainAxisAlignment.end : MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        flex: 5,
                        child: ListView(
                        reverse: true,
                        children: messagesList,
                      ),
                    ),
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: myController,
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          FlatButton(
                            onPressed: (){onSendMessageClicked(context);},
                            child: Text(
                              'Send',
                              style: kSendButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                );
              } else {
                return Column(
                  mainAxisAlignment: isMyMessage? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      decoration: kMessageContainerDecoration,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: myController,
                              decoration: kMessageTextFieldDecoration,
                            ),
                          ),
                          FlatButton(
                            onPressed: (){
                            onSendMessageClicked(context);
                            },
                            child: Text(
                              'Send',
                              style: kSendButtonTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void onSendMessageClicked(BuildContext myContext)async{
    if(myController.text.trim().length == 0 ){
      Scaffold.of(myContext).showSnackBar(SnackBar(content: Text('Cant Send Empty Message')));
      return ;
    }
    String input = myController.text;
    myController.clear();

    final message = await _store.collection('messages').add({
      'sender':loggedInUser.email,
      'text' : input
    });
  }

  @override
  void dispose() {
    myController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}
