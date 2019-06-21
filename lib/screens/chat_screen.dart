import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/utils/ChatCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {


  static const id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final myController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser ;

  final _firestorage = FirebaseStorage.instance;
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
                  String messageText = message['content'];
                  String messageSender = message['sender'];
                  int messageType = message['type'];

                  isMyMessage = messageSender == loggedInUser.email;
                  messagesList.add(ChatCard(
                    email: messageSender,
                    messageContentType: messageType,
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
                          Container(
                            width: 40,
                            height: 40,
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  onImageCapture(context);
                                },
                                child: Center(child: Icon(
                                  Icons.camera_alt, size: 20,
                                  color: Colors.lightBlueAccent,)),
                              ),
                            ),
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
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

  void onSendMessageClicked(BuildContext myContext) {
    if(myController.text.trim().length == 0 ){
      Scaffold.of(myContext).showSnackBar(SnackBar(content: Text('Cant Send Empty Message')));
      return ;
    }

    pushMessage(myController.text, loggedInUser.email, 1);
    myController.clear();
  }

  @override
  void dispose() {
    myController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void pushMessage(String text, String email, int messageType) async {
    final message = await _store.collection('messages').add({
      'sender': email,
      'content': text,
      'type': messageType
    });
  }

  void onImageCapture(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    image = await FlutterNativeImage.compressImage(image.path,
        quality: 50, percentage: 50);


    //print( "image.path is ${image.path}" );

    String imageName = loggedInUser.email + Random().nextInt(999).toString() +
        ".jpg";

    final StorageUploadTask uploadTask = _firestorage.ref().child(
        "chatImages/$imageName").putFile(image);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL IS $url");
    await pushMessage(url, loggedInUser.email, 2);
    print("Saving Success");
  }
}
