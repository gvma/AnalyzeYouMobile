import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:analyze_you/video_analysis.dart';
import 'package:analyze_you/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatelessWidget {
  HomePage({Key key, this.title, this.user, this.googleSignIn, this.googleUser, this.googleIdToken, this.googleAccessToken}) : super(key: key);
  final String title;
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  final GoogleSignInAccount googleUser;
  final String googleIdToken;
  final String googleAccessToken;

  Future<void> _signOut(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    GoogleSignIn().disconnect();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void typeVideoURL(BuildContext context) {
    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => VideoAnalysis(
            googleIdToken: googleIdToken,
            googleAccessToken: googleAccessToken,
            username: user.displayName,
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
//    Future<Map> response;
//    Get get = new Get(
//        url: "https://api-analyzeyou.herokuapp.com/channel_details/"
//    );
//    response = get.makeGetRequestToChannelDetails();
    //"https://api-analyzeyou.herokuapp.com/channel_details
    Firestore.instance.collection('UserData')
        .where("username", isEqualTo: "guiga")
        .snapshots().listen((onData) => onData.documents.forEach((doc) => print(doc["video_link"])));
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("AnalyzeYou"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.photoUrl)
                )
              ),
//            children: <Widget>[
//
//
//            ],
          ),
        ),
        // TODO ADICIONAR WIDGET COM PROFILE_IMAGE_LINK, VIEWS, SUBS E TITLE
        endDrawer: Drawer(
          child: ListView(
            addRepaintBoundaries: true,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Image.network(user.photoUrl),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(user.displayName,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          )
                      ),
                    ),
                  ]
                ),
                decoration: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.blue[900],
                    style: BorderStyle.solid,
                  )
                ),
              ),
            ]+ListTile.divideTiles(
                context: context,
                color: Colors.black,
                tiles:
                <Widget>[
                  ListTile(
                      title: Text(
                        "Analyze one of your videos",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]
                        ),
                      ),
                      onTap: () => typeVideoURL(context)
                  ),
                  ListTile(
                      title: Text(
                          "Sign out",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:  Colors.blue[900],
                        ),
                      ),
                      onTap: () => _signOut(context))
                ],
              ).toList(),
            )
        ),
      )
    );
  }
}