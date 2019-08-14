import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:analyze_you/get.dart';
import 'package:flutter/rendering.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VideoAnalysis extends StatefulWidget {
  VideoAnalysis({Key key, this.googleIdToken, this.googleAccessToken, this.username, this.user})
      : super(key: key);
  final String googleIdToken;
  final String googleAccessToken;
  final String username;
  final FirebaseUser user;

  _VideoAnalysisState createState() => _VideoAnalysisState(
      googleIdToken: googleIdToken,
      googleAccessToken: googleAccessToken,
      username: username
  );
}

class _VideoAnalysisState extends State<VideoAnalysis> {
  _VideoAnalysisState({this.googleIdToken, this.googleAccessToken, this.username});
  Widget graphs = Center(
    child: SizedBox(
        height: 300,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset("assets/AY.PNG"),
        )
    ),
  );
  final String googleIdToken;
  final String googleAccessToken;
  final String username;
  Widget loadImages() {
    return Center(
      child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900])
      ),
    );
  }

  Widget images(BuildContext context, Future<Map> images, String videoLink) {
    return FutureBuilder<Map> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // finally, the images are loaded
          Iterable<dynamic> json = snapshot.data.values;
          Iterable<dynamic> images = json.take(3);
          print(widget.user.uid);
          if (googleIdToken != null) {
            Firestore.instance.collection("UserData").document(widget.user.uid).collection("AnalyzedVideos").document().setData({
              "image_link": json.elementAt(0),
              "negative_comment_count": json.elementAt(3)[0],
              "positive_comment_count": json.elementAt(3)[1],
              "uid": widget.user.uid,
              "video_link": videoLink
            });
          }
          final graphics = images.map((url) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(url)),
          ).toList();
//           creating a Photo Gallery to see the photos with ease
          return PhotoViewGallery(
            scrollDirection: Axis.vertical,
            pageOptions: graphics,
            backgroundDecoration: BoxDecoration(
              color: Colors.white
            ),
          );
        } else {
          return Center(
            // while the images aren't loaded yet
            child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900])
            ),
          );
        }
      },
      future: images,
    );
  }

  void sendAndEraseText(BuildContext context, String value, TextEditingController _controller) {
    Future<Map> response;
    // Trying to get a response from the server
    try {
      Get get = new Get(
        url: "https://api-analyzeyou.herokuapp.com/statistics/"
      );
      // getting response from server
     response = get.makeGetRequestToVideoAnalysis(_controller.text);
      // url = https://api-analyzeyou.herokuapp.com/statistics/
    } catch (e) {
      print('Error while fetching data');
      return;
    }
    // popping a screen to update the next one
    Navigator.pop(context);
    setState(() => graphs = images(context, response, _controller.text));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    String value = "";
    final TextEditingController _controller = new TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('AnalyzeYou'),
        centerTitle: true,
      ),
      body: graphs,
      floatingActionButton: RaisedButton.icon(
        label: Text(
          "Put your link here!",
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold,
          )
        ),
        icon: Icon(
          Icons.link,
          color: Colors.blue[900],
        ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                actions: <Widget>[
                  RaisedButton(
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Center(
                      child: Text(
                        "Send video",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widthFactor: 1.3,
                    ),
                    onPressed: () => sendAndEraseText(context, value, _controller),
                  ),
                ],
                content: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  decoration: new InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ex: youtube.com/watch?v=xxx',
                  ),
                ),
              );
            }
          )
      ),
    );
  }
}