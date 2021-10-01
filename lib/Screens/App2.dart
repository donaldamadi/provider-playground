import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_notifs/Screens/App1.dart';
import 'package:push_notifs/provider/userModel.dart';

import '../main.dart';
import '../user.dart';

class ScreenZero extends StatefulWidget {
  @override
  _ScreenZeroState createState() => _ScreenZeroState();
}

class _ScreenZeroState extends State<ScreenZero> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

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
                controller: _nameController,
                onChanged: (val) {
                  userModel.setUsers(name: val);
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _numberController,
                onChanged: (val) {
                  userModel.setUsers(number: val);
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                onChanged: (val) {
                  userModel.setUsers(email: val);
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 5,
              child: ElevatedButton(
                child: Text("Go to next page"),
                onPressed: () async {
                  print(_nameController.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ResponsiveLayoutBuilder()));
                  // print(userModel.user?.name);
                  // print(userModel.user?.email);
                  // print(userModel.user?.number);
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
            ),
            SizedBox(height: 20),
            // userModel.user == null
            //     ? Container()
            //     :
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(userModel.user!.name == null ? "empty" : userModel.user!.name!, style: TextStyle(fontSize: 15)),
                  // Text(userModel.user!.number == null ? "empty" : userModel.user!.number!, style: TextStyle(fontSize: 15)),
                  // Text(userModel.user!.email == null ? "empty" : userModel.user!.email!, style: TextStyle(fontSize: 15)),
                  Text(_nameController.text, style: TextStyle(fontSize: 15)),
                  Text(_emailController.text, style: TextStyle(fontSize: 15)),
                  Text(_numberController.text, style: TextStyle(fontSize: 15)),
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
