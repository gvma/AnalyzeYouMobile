import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Get {
  Get({this.userToken});
  final String url = "https://api-analyzeyou.herokuapp.com/statistics/";
  Map<String, dynamic> map;
  final String userToken;

  Future<Map> makeGetRequest(String videoLink) async {
    print(this.url+"?video_link="+videoLink);
    http.Response response = await http.get(this.url+"?video_link="+videoLink);
    int statusCode = response.statusCode;
    print("Status code: $statusCode");
    return jsonDecode(response.body);
  }

}