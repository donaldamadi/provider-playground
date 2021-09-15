import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class ScreenOne extends StatefulWidget {

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Screen One')),
      
    );
  }}