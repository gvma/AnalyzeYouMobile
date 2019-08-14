import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Get {
  Get({this.url});
  final String url;
  Map<String, dynamic> map;

  Future<Map> makeGetRequestToVideoAnalysis(String videoLink) async {
    http.Response response = await http.get(this.url+"?video_link="+videoLink);
    int statusCode = response.statusCode;
    print("Status code: $statusCode");
    return jsonDecode(response.body);
  }

  Future<Map> makeGetRequestToChannelDetails() async {
    http.Response response = await http.get(this.url);
    int statusCode = response.statusCode;
    print("Status code: $statusCode");
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  }

}