import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:analyze_you/video_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.user, this.googleSignIn, this.googleUser, this.googleIdToken, this.googleAccessToken}) : super(key: key);
  final String title;
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;
  final GoogleSignInAccount googleUser;
  final String googleIdToken;
  final String googleAccessToken;
  _HomePageState createState() => _HomePageState(
    googleAccessToken: googleAccessToken,
    googleIdToken: googleIdToken,
    user: user,
  );
}

class _HomePageState extends State<HomePage> {
  _HomePageState({this.user, this.googleIdToken, this.googleAccessToken});
  final FirebaseUser user;
  final String googleIdToken;
  final String googleAccessToken;
  Widget positiveImage = SizedBox.shrink();
  String positiveURL = "";
  Widget negativeImage = SizedBox.shrink();
  String negativeURL = "";
  String positiveVideo = "";
  String negativeVideo = "";
  Map<String, Widget> images= {"positive": SizedBox.shrink(), "negative": SizedBox.shrink()};

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
              user: user,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    // query for positive comments
    Firestore.instance
        .collection('UserData')
        .document(user.uid)
        .collection("AnalyzedVideos")
        .orderBy("positive_comment_count", descending: true)
        .snapshots()
        .listen((data)  {
          if (data.documents.length > 0) {
            if (positiveURL != data.documents[0].data["image_link"]) {
              positiveURL = data.documents[0].data["image_link"];
              positiveVideo = data.documents[0].data["video_link"];
              setState(() => positiveImage = Image.network(
                data.documents[0].data["image_link"],
                fit: BoxFit.fitWidth,
                height: 260.0,
                width: 260.0,
              ));
            }
          }
        });
    // query for negative comments
    Firestore.instance
        .collection('UserData')
        .document(user.uid)
        .collection("AnalyzedVideos")
        .orderBy("negative_comment_count", descending: true)
        .snapshots()
        .listen((data) {
          print(data.documents.length);
          if (data.documents.length > 0) {
            if (negativeURL != data.documents[0].data['image_link']) {
              negativeURL = data.documents[0].data['image_link'];
              negativeVideo = data.documents[0].data["video_link"];
              setState(() => negativeImage = Image.network(
                data.documents[0].data["image_link"],
                fit: BoxFit.fitHeight,
                height: 260.0,
                width: 260.0,
              ));
            }
          }
        });
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue[900],
            title: Text("AnalyzeYou"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Center(),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    user.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      fontFamily: 'Lato',
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
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
                  ),
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue[900],
                            style: BorderStyle.solid,
                          ),
                          shape: BoxShape.rectangle
                      ),
                      child: Text(
                        "Most Positive Video: "+positiveVideo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    positiveImage,
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue[900],
                          style: BorderStyle.solid,
                        ),
                        shape: BoxShape.rectangle
                      ),
                      child: Text(
                        "Most Negative Video: "+negativeVideo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    negativeImage,
                  ],
                ),
              ],
            ),
          ),
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