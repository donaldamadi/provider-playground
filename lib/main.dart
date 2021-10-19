import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:push_notifs/firebaseMessaging.dart';
import 'package:push_notifs/provider/userModel.dart';
import 'package:push_notifs/screen_one.dart';
import 'package:http/http.dart' as http;
import 'package:push_notifs/screen_two.dart';
import 'package:push_notifs/user.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'Screens/App2.dart';

void main() async {
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
        ],
        child: MyApp(),
      ), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      // builder: DevicePreview.appBuilder,
      builder: (context, widget) => ResponsiveWrapper.builder(ScreenZero(),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            ResponsiveBreakpoint.resize(480, name: MOBILE),
            ResponsiveBreakpoint.autoScale(800, name: TABLET),
            ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          ],
          background: Container(color: Color(0xFFF5F5F5))),
      home: ScreenZero(),
    );
  }
}

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandler> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  // late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    saveDeviceToken();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message?.data);
      if (message != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ScreenOne()));
      }
    });
    fcm.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print(message.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Hi Obi'),
      ));
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message.data);
      // print('A new onMessageOpenedApp event was published');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ScreenOne()));
    });
  }

  saveDeviceToken() async {
    //Get the current User
    var uuid = Uuid();
    String uid = uuid.v4();

    // Get the token from this device
    String? fcmToken = await fcm.getToken();

    //Save it to firestore
    if (fcmToken != null) {
      var tokenRef = db.collection('users').doc(uid);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 200,
        width: 70,
        child: Column(
          children: [
            ElevatedButton(
              child: Center(child: Text('Notify')),
              onPressed: () async {
                var serverKey = 'server_key';
                DocumentSnapshot ref = await db
                    .collection('users')
                    .doc('dd0c6e48-f9f3-449f-8175-c90e2e358ebb')
                    .get();
                print(ref['token']);
                try {
                  http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                      'Authorization': 'key=$serverKey'
                    },
                    body: jsonEncode(
                      <String, dynamic>{
                        'notification': <String, dynamic>{
                          'body': 'Hi Obinna',
                          'title': 'Greetings from this side'
                        },
                        'priority': 'high',
                        'data': <String, dynamic>{
                          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                          'id': '1',
                          'status': 'done',
                          'message': 'lease_page'
                        },
                        'to':
                            "cTrDMU5-TyqvV8nX2k0wC6:APA91bGLYyVb6Hi9AY4f4EXkmZnMmrdDFCpGHZJCJZtH_gbwVK_bNgLjjbw0g5VReJJ52yKKjGGyYnmizrKYUCDoJRI6RJcqXezISI95GZXfy4P1IoFJA0wxPb1MaieZU-jPgZZsR8iT"
                      },
                    ),
                  );
                } catch (e) {
                  print("error push notification");
                }
              },
            ),
            SizedBox(height: 25),
            ElevatedButton(
                onPressed: () async {
                  /* DocumentSnapshot ref = await  */ db
                      .collection('users')
                      .doc('2c00621b-29ea-4553-af38-6b29e6969b64')
                      .update({
                    'token': FieldValue.delete(),
                    'createdAt': FieldValue.delete(),
                    'platform': FieldValue.delete()
                  }).whenComplete(() {
                    print('field deleted');
                  });
                },
                child: Center(
                  child: Text('Delete Token'),
                ))
          ],
        ),
      ),
    ));
  }
}


// ref.docs.forEach((snapshot) async {
//                 http.Response response = await http.post(
//                   Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                   headers: <String, String>{
//                     'Content-Type': 'application/json',
//                     'Authorization': 'key=$serverKey',
//                   },
//                   body: jsonEncode(
//                     <String, dynamic>{
//                       'notification': <String, dynamic>{'body': 'Hello There!, This is my first notification using push requests', 'title': 'Hi User!'},
//                       'priority': 'high',
//                       'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
//                       'to': snapshot['tokens'],
//                     },
//                   ),
//                 );
//                 print("Data: ${snapshot['tokens']}");
//                 print('done one');
//               });
//               print('done');
