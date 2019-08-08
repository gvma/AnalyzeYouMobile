import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:analyze_you/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:analyze_you/video_analysis.dart';

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
//    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(title: title)));
  }

  void typeVideoURL(BuildContext context) {
    Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => VideoAnalysis(
            googleIdToken: googleIdToken,
            googleAccessToken: googleAccessToken
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Access token: "+googleAccessToken);
    print("Id token: "+googleIdToken);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("AnalyzeYou"),
          centerTitle: true,
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
//                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        )
                      ),
                    ),

                  ],
                ),
                decoration: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.red,
                    style: BorderStyle.solid,
                    width: 2.0
                  )
                ),
              ),
            ]+ListTile.divideTiles(
                context: context,
                color: Colors.black,
                tiles:
                <Widget>[
                  ListTile(title: Text("Analyze one of your videos"), 
                      onTap: () => typeVideoURL(context)
                      
                  ),
                  ListTile(title: Text("Sign out"), onTap: () => _signOut(context))
                ],
              ).toList(),
            )
        ),
      )
    );
  }
}