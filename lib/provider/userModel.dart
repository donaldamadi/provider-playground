import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:push_notifs/user.dart';

class UserModel extends ChangeNotifier {
  String? token;
  List<User>? users;
  User? user;

  void setToken(String token) {
    this.token = token;
    notifyListeners();
  }

  // void setUsers(List<User> users){
  //   this.users = users;
  //   notifyListeners();
  // }

  void setUser(User user) {
    this.user = user;
    notifyListeners();
  }

  void setUsers({String? email, String? name, String? number}) {
    if (email != null) {
      this.user?.email = email;
      print(email);
      notifyListeners();
    }
    if (name != null) {
      this.user?.name = name;
      notifyListeners();
    }
    if (number != null) {
      this.user?.number = number;
      notifyListeners();
    }
  }

  // void setEmail(String email){
  //   this.user?.email = email;
  //   notifyListeners();
  // }

  // void setName(String name){
  //   this.user?.name = name;
  //   notifyListeners();
  // }

  // void setNumber(String number){
  //   this.user?.number = number;
  //   notifyListeners();
  // }

}
