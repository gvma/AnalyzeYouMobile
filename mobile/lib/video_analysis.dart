import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:analyze_you/get.dart';
import 'package:flutter/rendering.dart';

class VideoAnalysis extends StatefulWidget {
  VideoAnalysis({Key key, this.googleIdToken, this.googleAccessToken})
      : super(key: key);
  final String googleIdToken;
  final String googleAccessToken;
  _VideoAnalysisState createState() => _VideoAnalysisState(googleIdToken: googleIdToken, googleAccessToken: googleAccessToken);
}

class _VideoAnalysisState extends State<VideoAnalysis> {
  _VideoAnalysisState({this.googleIdToken, this.googleAccessToken});
  Widget graphs = SizedBox.shrink();
  final String googleIdToken;
  final String googleAccessToken;
  Widget loadImages() {
    return Center(
      child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)
      ),
    );
  }

  Widget images(BuildContext context, Future<Map> images) {
    return FutureBuilder<Map> (
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Iterable<dynamic> it = snapshot.data.values;
          final graphics = it.map((url) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(url))
          ).toList();
          return PhotoViewGallery(
            scrollDirection: Axis.vertical,
            pageOptions: graphics,
            backgroundDecoration: BoxDecoration(
              color: Colors.white
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
                strokeWidth: 3.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)
            ),
          );
        }
      },
      future: images,
    );
  }

  void sendAndEraseText(BuildContext context, String value, TextEditingController _controller) {
    Future<Map> response;
    try {
      Get get = new Get(
        userToken: this.googleAccessToken
      );
     response = get.makeGetRequest(_controller.text);
     if (response == null) {
       print("Response eh null");
     }
      // url = https://api-analyzeyou.herokuapp.com/statistics/
    } catch (e) {
      //TODO printar dizendo que não existe um link para esse video
      print(e.toString());
    }
//    response[''];]
    Navigator.pop(context);
    _controller.clear();
    setState(() => graphs = images(context, response));
  }

  @override
  Widget build(BuildContext context) {
    String value = "";
    final TextEditingController _controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('AnalyzeYou'),
        centerTitle: true,
      ),
      body: graphs,
      floatingActionButton: RaisedButton.icon(
        label: Text("Put your link here!"),
        icon: Icon(Icons.link),
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            gapPadding: 1000
          ),
          onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  actions: <Widget>[
                    RaisedButton(
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          "Send video",
                          style: TextStyle(
                            color: Colors.white70
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
                      hintText: 'Put your link here...'
                    ),
                  ),
                );
              }
          )
      ),
//      body: Column(
//        children: <Widget>[
//          Padding(
//              padding: EdgeInsets.all(16),
//              child: TextField(
//                  controller: _controller,
//                  textInputAction: TextInputAction.send,
//                  decoration: new InputDecoration(
//                    border: OutlineInputBorder(),
//                    hintText: 'Put your link here...',
//                    hintStyle: TextStyle(
//                        fontWeight: FontWeight.w300,
//                        color: Colors.grey
//                    ),
//                  )
//              )
//          ),
//
//          graphs
//        ],
//      ),
    );
  }
}