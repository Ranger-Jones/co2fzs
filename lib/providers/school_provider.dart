import 'package:co2fzs/models/school.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:co2fzs/resources/auth_methods.dart';

class SchoolProvider with ChangeNotifier {
  School? _school;
  final AuthMethods _authMethods = AuthMethods();

  School get getSchool =>
      _school ??
      School(
        schoolId: 1,
        id: "none",
        schoolname: "none",
        location: "none",
        classes: "none",
        totalPoints: 0,
        users: [],
        contestId: "none",
      );

  Future<void> refreshSchool() async {
    School? school = await _authMethods.getSchoolDetails();
    _school = school;
    notifyListeners();
  }
}
