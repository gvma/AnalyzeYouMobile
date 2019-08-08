import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:analyze_you/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:analyze_you/video_analysis.dart';

class ImageLinks {
  String _sentiment_result;
  String _time_series;
  String _word_cloud;

  ImageLinks.fromJSON(Map<String, dynamic> jsonMap) :
    _sentiment_result = jsonMap['sentiment_result'],
    _time_series = jsonMap['time_series'],
    _word_cloud = jsonMap['word_cloud'];

  String get word_cloud => _word_cloud;

  String get time_series => _time_series;

  String get sentiment_result => _sentiment_result;


}