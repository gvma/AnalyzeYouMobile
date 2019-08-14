import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Get {
  Get({this.url});
  final String url;
  Map<String, dynamic> map;

  Future<Map> makeGetRequest(String videoLink) async {
    http.Response response = await http.get(this.url+"?video_link="+videoLink);
    int statusCode = response.statusCode;
    print("Status code: $statusCode");
    return jsonDecode(response.body);
  }
}