import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:co2fzs/resources/auth_methods.dart';

class SchoolClassProvider with ChangeNotifier {
  SchoolClass? _schoolClass;
  final AuthMethods _authMethods = AuthMethods();

  SchoolClass get getSchoolClass =>
      _schoolClass ??
      SchoolClass(
        name: "none",
        totalPoints: 0,
        schoolIdBlank: "none",
        users: "none",
        id: "none",
        userCount: 1,
      );

  Future<void> refreshSchoolClass() async {
    SchoolClass? schoolClass = await _authMethods.getSchoolClassDetails();
    _schoolClass = schoolClass;
    notifyListeners();
  }
}
