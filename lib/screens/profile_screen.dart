import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/contest.dart';
import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/screens/class_detail_screen.dart';
import 'package:co2fzs/screens/school_detail_screen.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/icon_info.dart';
import 'package:co2fzs/widgets/info_button.dart';
import 'package:co2fzs/widgets/logout_button.dart';
import 'package:co2fzs/widgets/route_info.dart';
import 'package:co2fzs/widgets/statistic_bar_container.dart';
import 'package:co2fzs/widgets/table_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  User? otherProfile;
  final bool otherProfileState;
  ProfileScreen({Key? key, this.otherProfile, this.otherProfileState = false})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  School? school;
  Contest? contest;
  SchoolClass? schoolClass;
  List<model.Route> routes = [];

  String mostUsedTransportOption = "Auto";

  int _routeLoadingAttempt = 0;
  int _contestLoadingAttempt = 0;

  double userPoints = 0;
  double averagePoints = 0;

  bool _isLoading = false;
  bool _schoolLoaded = false;
  bool _contestLoaded = false;
  bool _routesLoaded = false;
  bool _schoolClassLoaded = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void loadSchool(BuildContext context) async {
    User? user;
    if (widget.otherProfileState) {
      user = widget.otherProfile;
    } else {
      user = Provider.of<UserProvider>(context, listen: false).getUser;
    }
    setState(() {
      _isLoading = true;
    });
    var res = await FirestoreMethods().catchSchool(
      schoolId: user!.schoolId,
    );
    if (res == "Undefined Error" ||
        res == "SchulID ist inkorrekt" ||
        res is String) {
      showSnackBar(context, res);
      return loadSchool(context);
    } else {
      school = School.fromSnap(res);
      setState(() {
        _schoolLoaded = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void loadClass(BuildContext context) async {
    User? user;
    if (widget.otherProfileState) {
      user = widget.otherProfile;
    } else {
      user = Provider.of<UserProvider>(context, listen: false).getUser;
    }
    setState(() {
      _isLoading = true;
    });
    var res = await FirestoreMethods().catchClass(
      schoolIdBlank: user!.schoolIdBlank,
      classId: user.classId,
    );
    if (res is String) {
      showSnackBar(context, res);
      return loadClass(context);
    } else {
      schoolClass = SchoolClass.fromSnap(res);
      setState(() {
        _schoolClassLoaded = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void loadContest(BuildContext context) async {
    User? user;
    if (widget.otherProfileState) {
      user = widget.otherProfile;
    } else {
      user = Provider.of<UserProvider>(context, listen: false).getUser;
    }
    setState(() {
      _isLoading = true;
      _contestLoadingAttempt++;
    });
    if (_contestLoadingAttempt > 4) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    var res = await FirestoreMethods().catchContest(
      contestId: user!.contestId,
    );
    if (res == "Undefined Error" || res is String) {
      // showSnackBar(context, res);
      return loadContest(context);
    } else {
      contest = Contest.fromSnap(res);
    }

    setState(() {
      _contestLoaded = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  void loadRoutes(BuildContext context) async {
    User? user;
    if (widget.otherProfileState) {
      user = widget.otherProfile;
    } else {
      user = Provider.of<UserProvider>(context, listen: false).getUser;
    }
    setState(() {
      _isLoading = true;
      _routeLoadingAttempt++;
      routes = [];
    });

    if (_routeLoadingAttempt > 4) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var res = await FirestoreMethods().catchRoutes(
      uid: user!.uid,
    );

    if (res == "Undefined Error" || res is String) {
      // showSnackBar(context, res);
      return loadRoutes(context);
    } else {
      print("Documents: $res");
      res.forEach((e) => routes.add(model.Route.fromSnap(e)));
      setState(() {
        averagePoints = calculateAveragePoints(res.length, user!.totalPoints);
        mostUsedTransportOption = calculateAverageTransportOption();
        _routesLoaded = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  double calculateAveragePoints(
      int totalDocumentsLength, double totalPointsUser) {
    return (totalPointsUser / totalDocumentsLength);
  }

  String calculateAverageTransportOption() {
    double carCount = 0;
    routes.where((element) => element.transport == "car").forEach((e) {
      carCount += e.points;
    });
    double ptCount = 0;

    routes.where((element) => element.transport == "pt").forEach((e) {
      ptCount += e.points;
    });

    double bicycleCount = 0;

    routes.where((element) => element.transport == "bicycle").forEach((e) {
      bicycleCount += e.points;
    });

    double walkCount = 0;

    routes.where((element) => element.transport == "walk").forEach((e) {
      walkCount += e.points;
    });

    Map<String, double> transportListCount = {
      "Auto": carCount,
      "ÖPNV": ptCount,
      "Fahrrad": bicycleCount,
      "Zu Fuß": walkCount,
    };

    double largestValue = 0;
    String mostUsedTransport = "Auto";

    transportListCount.forEach((key, value) {
      if (value > largestValue) {
        largestValue = value;
        mostUsedTransport = key;
      }
    });
    return mostUsedTransport;
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    if (DateFormat.yMMMMd().format(startDate).toString() !=
        DateFormat.yMMMMd().format(endDate).toString()) {
      for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
        DateTime _tmpDate = startDate.add(Duration(days: i));
        if (DateFormat.E().format(_tmpDate).toString()[0] != "S") {
          days.add(startDate.add(Duration(days: i)));
        }
      }
    } else {
      days.add(startDate);
    }
    return days;
  }

  double dailyPoints(DateTime date) {
    List<model.Route> _routesToday = [];

    setState(() {
      _routesToday = [];
    });
    int index = 0;
    setState(() => index = 0);
    _routesToday = routes
        .map((element) {
          if (element != null) {
            if (DateFormat.yMMMMd().format(element.date.toDate()).toString() ==
                DateFormat.yMMMMd().format(date).toString()) {
              if (!_routesToday.contains(element)) {
                if (index < 2) {
                  index++;
                  return element;
                } else {
                  return model.Route.emptyRoute();
                }
              } else {
                return model.Route.emptyRoute();
              }
            } else {
              return model.Route.emptyRoute();
            }
          } else {
            return model.Route.emptyRoute();
          }
        })
        .cast<model.Route>()
        .toList();
    double dailyPoints = 0;
    setState(() {
      dailyPoints = 0;
    });

    index = 0;
    print("${_routesToday.toString()}");
    _routesToday.forEach((element) {
      dailyPoints += element != null ? element.points : 0;
// ${DateFormat.yMMMMd().format(element.date.toDate()).toString()}
      // print(
      //     "INDEX ${index}:  | ${dailyPoints} | ${element.toJson().toString()}");
    });

    return dailyPoints;
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    if (widget.otherProfileState) {
      user = widget.otherProfile;
    } else {
      user = Provider.of<UserProvider>(
        context,
      ).getUser;
    }

    // School school = Provider.of<SchoolProvider>(
    //   context,
    // ).getSchool;
    // SchoolClass schoolClass = Provider.of<SchoolClassProvider>(
    //   context,
    // ).getSchoolClass;

    userPoints = user!.totalPoints;
    if (!_schoolLoaded) {
      loadSchool(context);
    }
    if (!_contestLoaded && _contestLoadingAttempt < 5) {
      loadContest(context);
    }
    if (!_routesLoaded && _routeLoadingAttempt < 5) {
      if (routes.isEmpty) {
        loadRoutes(context);
      }
    }
    if (!_schoolClassLoaded) {
      loadClass(context);
    }
    // if (school.schoolname == "none") {
    //   Provider.of<SchoolProvider>(
    //     context,
    //   ).refreshSchool();
    // }
    initializeDateFormatting();
    Intl.defaultLocale = 'de_DE';
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.075,
                      width: MediaQuery.of(context).size.height * 0.075,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          user.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(child: Container(), flex: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(user.firstname),
                                Text(" ${user.lastName[0]}."),
                              ],
                            ),
                            Text("@${user.username}",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        !widget.otherProfileState ? LogoutButton() : Container()
                      ],
                    )
                  ],
                ),
                Divider(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    children: [
                      Text(
                        (user.totalPoints == 0)
                            ? "0"
                            : "${user.totalPoints.toStringAsFixed(2)}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        "Punkte",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TableItem(
                  info: school!.schoolname,
                  label: "Schule",
                ),
                TableItem(
                  info: user.grade,
                  label: "Klasse",
                ),
                TableItem(
                  info: "${averagePoints.floorToDouble()}",
                  label: "Durchnittliche Punkte",
                ),
                TableItem(
                  info: mostUsedTransportOption,
                  label: "Meistgenutztes Fahrzeug",
                ),
                SizedBox(height: 20),
                Text(
                  "Statistik",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                routes.isEmpty
                    ? Text("no data")
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          primary: false,
                          children: getDaysInBetween(
                            contest!.startDate.toDate(),
                            DateTime.now(),
                          )
                              .map((e) => StatisticBarContainer(
                                    date: e,
                                    totalPoints: user!.totalPoints,
                                    dailyPoints: dailyPoints(e),
                                  ))
                              .toList(),
                        ),
                      ),
                SizedBox(height: 20),
                !widget.otherProfileState
                    ? Column(
                        children: [
                          Text(
                            "Meine Rankings",
                            style: Theme.of(context).textTheme.headline3,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              primary: false,
                              children: [
                                InfoButton(
                                  assetUrl: "assets/images/school.svg",
                                  label: "Meine\nSchule",
                                  backgroundColor: secondaryColor,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => SchoolDetailScreen(
                                            school: school!)),
                                  ),
                                ),
                                InfoButton(
                                  assetUrl: "assets/images/classroom.svg",
                                  label: "Meine\nKlasse",
                                  backgroundColor: lightBlue,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => ClassDetailScreen(
                                            schoolClass: schoolClass!)),
                                  ),
                                ),
                                // InfoButton(
                                //   assetUrl: "assets/images/people.svg",
                                //   label: "Meine\nFreunde",
                                //   backgroundColor: lightPurple,
                                //   onTap: () {},
                                // ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 20),
                Text(
                  "Meine Einträge",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .collection("routes")
                      .orderBy("date")
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Divider(),
                            RouteInfo(
                              route: model.Route.fromSnap(
                                snapshot.data!.docs[index],
                              ),
                              otherProfileState: widget.otherProfileState,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
