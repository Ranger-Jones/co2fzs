import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser =>
      _user ??
       User(
        username: "none",
        email: "none",
        uid: "none",
        schoolId: 1,
        operationLevel: 1,
        schoolIdBlank: "none",
        firstname: "none",
        lastName: "none",
        grade: "none",
        photoUrl: "none",
        role: "none",
        totalPoints: 0,
        homeAddress: "none",
        homeAddress2: "none",
        disqualified: true,
        classId: "none",
        contestId: "none",
        transport: "none",
        activated: false,
        datePublished: DateTime.now(),
        dateUpdated: DateTime.now(),
        friends: []
      );

  Future<void> refreshUser() async {
    User? user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
