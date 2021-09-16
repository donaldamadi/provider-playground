import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:push_notifs/provider/userModel.dart';
import 'package:push_notifs/screen_one.dart';
import 'package:http/http.dart' as http;
import 'package:push_notifs/screen_two.dart';
import 'package:push_notifs/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<UserModel>(create: (context) => UserModel()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScreenZero(),
    );
  }
}

class ScreenZero extends StatefulWidget {
  @override
  _ScreenZeroState createState() => _ScreenZeroState();
}

class _ScreenZeroState extends State<ScreenZero> {
  String? name;
  String? email;
  String? number;
  List<User>? newList;

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Providers"),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  userModel.setUsers(name: val);
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  userModel.setUsers(number: val);
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (val) {
                  userModel.setUsers(email: val);
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Go to next page"),
              onPressed: () async {
                print(userModel.user?.name);
                print(userModel.user?.email);
                print(userModel.user?.number);
                // SharedPreferences prefs = await SharedPreferences.getInstance();
                // await prefs.setString("token", "BHDUBIUDIU626728HDHBSJBHIJKSNKS");
                // prefs.getString("token");
                // await prefs.setStringList("listOfUsers", []);
                // newList = userModel.users;
                // userModel.users?.add(User(name: name, email: email, number: number));
                // userModel.setUsers(newList ?? []);
                // print(userModel.users);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenTwo()));
              },
            ),
            SizedBox(height: 20),
            userModel.user == null
                ? Container()
                : Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userModel.user!.name == null ? "empty" : userModel.user!.name!, style: TextStyle(fontSize: 15)),
                        Text(userModel.user!.number == null ? "empty" : userModel.user!.number!, style: TextStyle(fontSize: 15)),
                        Text(userModel.user!.email == null ? "empty" : userModel.user!.email!, style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: userModel.users?.length,
            //     itemBuilder: (BuildContext context, int index){
            //       return Padding(
            //         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(userModel.users![index].name!, style: TextStyle(fontSize: 15)),
            //             Text(userModel.users![index].email!, style: TextStyle(fontSize: 15)),
            //             Text(userModel.users![index].number!, style: TextStyle(fontSize: 15)),
            //           ],
            //         )
            //       );
            //     },
            //   )
            // )
          ],
        ),
      ),
    );
  }
}



//Here, I was trying to understand how push notifications work with firebase

class MyApp2 extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MessageHandler(),
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenOne()));
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
      Navigator.push(context, MaterialPageRoute(builder: (context) => ScreenOne()));
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
      await tokenRef.set({'token': fcmToken, 'createdAt': FieldValue.serverTimestamp(), 'platform': Platform.operatingSystem});
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
                DocumentSnapshot ref = await db.collection('users').doc('dd0c6e48-f9f3-449f-8175-c90e2e358ebb').get();
                print(ref['token']);
                try {
                  http.post(
                    Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    headers: <String, String>{'Content-Type': 'application/json', 'Authorization': 'key=$serverKey'},
                    body: jsonEncode(
                      <String, dynamic>{
                        'notification': <String, dynamic>{'body': 'Hi Obinna', 'title': 'Greetings from this side'},
                        'priority': 'high',
                        'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done', 'message': 'lease_page'},
                        'to': "cTrDMU5-TyqvV8nX2k0wC6:APA91bGLYyVb6Hi9AY4f4EXkmZnMmrdDFCpGHZJCJZtH_gbwVK_bNgLjjbw0g5VReJJ52yKKjGGyYnmizrKYUCDoJRI6RJcqXezISI95GZXfy4P1IoFJA0wxPb1MaieZU-jPgZZsR8iT"
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
                      .update({'token': FieldValue.delete(), 'createdAt': FieldValue.delete(), 'platform': FieldValue.delete()}).whenComplete(() {
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
