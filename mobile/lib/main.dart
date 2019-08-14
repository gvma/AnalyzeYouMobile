import 'package:flutter/material.dart';
import 'package:analyze_you/login_page.dart';

void main() => runApp(AnalyzeYouApp());

class AnalyzeYouApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnalyzeYou',
      home: LoginPage(title: 'AnalyzeYou'),
    );
  }
}

