import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/icon_info.dart';
import 'package:co2fzs/widgets/route_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  School? school;
  double userPoints = 0;
  bool _isLoading = false;
  bool _schoolLoaded = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadSchool() async {
    User user = Provider.of<UserProvider>(context).getUser;
    setState(() {
      _isLoading = true;
    });
    var res = await FirestoreMethods().catchSchool(
      schoolId: user.schoolId,
    );
    if (res == "Undefined Error" ||
        res == "SchulID ist inkorrekt" ||
        res is String) {
      showSnackBar(context, res);
      loadSchool();
    } else {
      school = School(
        schoolId: res["schoolId"],
        id: res["id"],
        schoolname: res["schoolname"],
        location: res["location"],
        classes: res["classes"],
        totalPoints: res["totalPoints"],
        users: res["users"],
        contestId: res["contestId"],
      );
      setState(() {
        _schoolLoaded = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(
      context,
    ).getUser;
    // School school = Provider.of<SchoolProvider>(
    //   context,
    // ).getSchool;
    // SchoolClass schoolClass = Provider.of<SchoolClassProvider>(
    //   context,
    // ).getSchoolClass;

    userPoints = user.totalPoints;
    if (!_schoolLoaded) {
      loadSchool();
    }
    // if (school.schoolname == "none") {
    //   Provider.of<SchoolProvider>(
    //     context,
    //   ).refreshSchool();
    // }
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 100,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                user.username,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconInfo(
                    iconData: Icons.class__sharp,
                    info: user.grade,
                  ),
                  school!.schoolname != "none"
                      ? IconInfo(
                          iconData: Icons.school,
                          info: school!.schoolname,
                        )
                      : CircularProgressIndicator(),
                  IconInfo(
                    iconData: Icons.circle_sharp,
                    info: "$userPoints",
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
