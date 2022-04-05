import 'package:co2fzs/models/contest.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/resources/auth_methods.dart';

class ContestProvider with ChangeNotifier {
  Contest? _contest;
  final AuthMethods _authMethods = AuthMethods();

  Contest get getContest =>
      _contest ??
      Contest(
        title: "none",
        id: "",
        startDate: null,
        endDate: null,
        schools: [],
      );

  Future<void> refreshContest() async {
    Contest? contest = await _authMethods.getContestDetails();
    _contest = contest;
    notifyListeners();
  }
}
