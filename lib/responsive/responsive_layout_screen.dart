import 'package:co2fzs/main.dart';
import 'package:co2fzs/models/contest.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart' as model;
import 'package:co2fzs/providers/contest_provider.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/responsive/mobile_screen_layout.dart';
import 'package:co2fzs/utils/config.dart';
import 'package:co2fzs/widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/dimensions.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({
    Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  model.User? user;
  School? school;
  SchoolClass? schoolClass;
  Contest? contest;
  String version = "v0";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addUserData();
  }

  addData() async {
    await addUserData();

    await addSchoolClassData();
    await addContestData();
  }

  addUserData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();

    user = _userProvider.getUser;

    if (user!.username == "none") {
      addUserData();
    }
  }

  addSchoolClassData() async {
    SchoolClassProvider _schoolClassProvider =
        Provider.of(context, listen: false);
    await _schoolClassProvider.refreshSchoolClass();

    SchoolClass schoolClass = _schoolClassProvider.getSchoolClass;

    if (schoolClass.name == "none") {
      addSchoolClassData();
    }
  }

  addContestData() async {
    ContestProvider _contestProvider = Provider.of(context, listen: false);
    await _contestProvider.refreshContest();

    Contest contest = _contestProvider.getContest;

    if (contest.title == "none") {
      addContestData();
    }
  }

  @override
  Widget build(BuildContext context) {
    //  FirebaseAuth.instance.signOut();
    // addData();

    if (user != null) {
      print(user!.toJson().toString());
      if (user!.role == "admin" || !user!.activated) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  "Möglicherweise wurde dein Account noch nicht aktiviert...\nMelde dich später erneut an.",
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                AuthButton(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => MyApp()),
                        (route) => false);
                  },
                  label: "Abmelden",
                )
              ],
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > webScreenSize) {
            return widget.webScreenLayout;
          }

          return widget.mobileScreenLayout;
        },
      );
    } else {
      user = Provider.of<UserProvider>(context).getUser;
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              AuthButton(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => MyApp()),
                      (route) => false);
                },
                label: "Abmelden",
              )
            ],
          ),
        ),
      );
    }
  }
}
