import 'package:connect_crowd/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class chat_screen extends StatefulWidget {
  const chat_screen({Key? key}) : super(key: key);
  static const String id = 'chat_screen';

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  late SharedPreferences logindata;
  final _auth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var imageurl;
  bool ifimage = false;

  final _firestore = FirebaseFirestore.instance;
  late User loggedinuser;
  late String messagetext;

  final messageTextController = TextEditingController();
  @override
  void initState() {
    getdata();
    super.initState();
  }

  void getdata() async {
    final details = await _auth.currentUser;
    try {
      if (details != null) {
        loggedinuser = details;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getimage() async {
    final picker = ImagePicker();
    final XFile? pickedimage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage == null) {
      imageurl = null;
    } else {
      String filename = pickedimage.name;
      File imagepath = File(pickedimage.path);

      var uploadimage = await firebaseStorage.ref(filename).putFile(imagepath);
      imageurl = await uploadimage.ref.getDownloadURL();
      ifimage = true;
      //String message=null;
      await _firestore.collection('messages').add({
        'imageurl': imageurl,
        'message': "",
        'user': loggedinuser.email,
        'time': FieldValue.serverTimestamp()
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Connect Crowd',
            style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w900, color: Colors.black)),
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () async {
                _auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => welcome_screen()),
                    (route) => false);

                //logindata.setBool('login', true);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    CircularProgressIndicator();
                  }

                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs.reversed;
                    List<Messagebubble> messageWidgets = [];
                    for (var message in messages) {
                      var data = message.data() as Map;
                      var messagetext = data['message'];
                      var messageuser = data['user'];
                      var imageURL = data['imageurl'];
                      var user = loggedinuser.email;
                      final messagewidget = Messagebubble(messageuser, imageURL,
                          messagetext, user == messageuser);
                      messageWidgets.add(messagewidget);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
                    );
                  }
                  return SizedBox();
                }),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messagetext = value;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                                  BorderSide(width: 3.0, color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(
                                    width: 3.0, color: Colors.black))),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        if (messageTextController.text == "") {
                          
                        } else {
                          _firestore.collection('messages').add({
                            'message': messageTextController.text,
                            'user': loggedinuser.email,
                            'time': FieldValue.serverTimestamp(),
                            'imageurl': ""
                          });
                          messageTextController.clear();
                        }
                      },
                      child: Text('Send')),
                  IconButton(
                      onPressed: () {
                        getimage();
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Messagebubble extends StatelessWidget {
  Messagebubble(this.user, this.image, this.message, this.isme);

  final String user;
  final String message;
  final bool isme;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            user,
            style: TextStyle(color: Colors.black),
          ),
          Material(
              borderRadius: isme
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0))
                  : BorderRadius.only(
                      bottomLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
              elevation: 10.0,
              color: isme ? Colors.blue : Colors.green,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: image != ""
                      ? Container(
                          child: CachedNetworkImage(
                          imageUrl: image,
                          fit: BoxFit.scaleDown,
                        ))
                      : Text(
                          message,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w900),
                        ))),
        ],
      ),
    );
  }
}
