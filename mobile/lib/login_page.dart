import 'package:flutter/material.dart';
import 'package:analyze_you/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn(
//    scopes: [
//      'email',
//      'https://www.googleapis.com/auth/youtube.readonly',
//      'https://www.googleapis.com/auth/yt-analytics.readonly'
//    ]
  );

  Future<void> _handleSignIn(BuildContext context) async {
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
            builder: (context) => HomePage(title: title,
                user: user,
                googleSignIn: _googleSignIn,
                googleUser: googleUser,
                googleIdToken: googleAuth.idToken,
                googleAccessToken : googleAuth.accessToken
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton.icon(
          icon: Image.network("https://www.google.com/favicon.ico"),
          label: Text("Login with Google"),
          onPressed: () => _handleSignIn(context)
        )
      ),
    );
  }
}
