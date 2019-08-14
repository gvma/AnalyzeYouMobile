import 'package:flutter/material.dart';
import 'package:analyze_you/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:analyze_you/video_analysis.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
    scopes: [
      'email'
    ]
  );

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      print("signed in " + user.displayName);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                  title: title,
                  user: user,
                  googleSignIn: _googleSignIn,
                  googleUser: googleUser,
                  googleIdToken: googleAuth.idToken,
                  googleAccessToken : googleAuth.accessToken
              )
          )
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 132,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset("assets/AY.PNG"),
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                RaisedButton.icon(
                  icon: Image.asset("assets/favicon.ico"),
                  label: Text(
                    "Login with Google",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900]
                    ),
                  ),
                  color: Colors.white70,
                  onPressed: () => _handleSignIn(context),
                  textTheme: ButtonTextTheme.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                ),
                RaisedButton.icon(
                  icon: Icon(
                    Icons.account_box,
                    color: Colors.blue[900],
                  ),
                  label: Text(
                    "Login as guest",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  color: Colors.white70,
                  textTheme: ButtonTextTheme.accent,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoAnalysis(
                        googleAccessToken: null,
                        googleIdToken: null,
                      )
                    )
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}
