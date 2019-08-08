import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Post {
  Post({this.linkVideo, this.userToken});
  final String linkVideo;
  final String userToken;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      linkVideo: json['link_video'],
      userToken: json['user_token']
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['link_video'] = linkVideo;
    map['user_token'] = userToken;
    return map;
  }

  static Future<Post> createPost(String url, {Map body}) async {
    final response = await http.post(url, body: body);
    final int statusCode = response.statusCode;
    print("STATUS CODE = $statusCode");
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching dataaaa!");
    }
    return Post.fromJson(json.decode(response.body));
    /*return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;
      print("STATUS CODE = $statusCode");
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching dataaaa!");
      }
      return Post.fromJson(json.decode(response.body));
    });*/
  }



}