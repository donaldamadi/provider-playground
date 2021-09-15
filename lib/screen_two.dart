import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_notifs/provider/userModel.dart';

class ScreenTwo extends StatefulWidget {

  @override
  _ScreenTwoState createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Screen Two"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(userModel.token!),
            ElevatedButton(onPressed: (){}, child: Text("Press me")),
          ],
        ),
      ),
    );
  }
}