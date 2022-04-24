import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/article.dart';
import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart' as model;
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/screens/add_route_screen.dart';
import 'package:co2fzs/utils/config.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/article_info.dart';
import 'package:co2fzs/widgets/article_info_row_card.dart';
import 'package:co2fzs/widgets/ranking_list_info.dart';
import 'package:co2fzs/widgets/ranking_stream.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import "package:charts_flutter/flutter.dart" as charts;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isLoading = false;
  bool _routesLoaded = false;
  int loadingAttempt = 0;
  String version = "v0";
  int routesToday = 0;
  bool weekEnd = false;

  List<model.Route> routes = [];

  void loadRoutes() async {
    model.User user = Provider.of<UserProvider>(context, listen: false).getUser;

    if (user.username == "none") {
      await Provider.of<UserProvider>(context, listen: false).refreshUser();
      return loadRoutes();
    }
    setState(() {
      _isLoading = true;
      loadingAttempt++;
    });

    if (loadingAttempt > 4) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var res = await FirestoreMethods().catchRoutes(
      uid: user.uid,
    );
    if (res == "Undefined Error" || res is String) {
      //showSnackBar(context, res);
      return loadRoutes();
    } else {
      print("Documents: $res");
      res.forEach((e) => routes.add(model.Route.fromSnap(e)));
      setState(() {
        _routesLoaded = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  checkWeekEnd() {
    if (DateFormat.E().format(DateTime.now()).toString()[0] == "S") {
      setState(() {
        weekEnd = true;
      });
    }
  }

  loadConfig() async {
    String res = await FirestoreMethods().catchConfig();
    print(res);
    if (res[0] == "v") {
      setState(() {
        version = res;
      });
    } else {
      return loadConfig();
    }
  }

  loadRoutesToday() async {
    try {
      var res = await FirestoreMethods().routesToday();
      if (res is String) {
        showSnackBar(context, res);
      } else if (res is int) {
        setState(() {
          routesToday = res;
        });
      }
      print("ROUTES TODAY: ${res}");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    loadConfig();
    loadRoutesToday();
    checkWeekEnd();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth.instance.signOut();
    model.User user = Provider.of<UserProvider>(
      context,
    ).getUser;

    if (version == "v0") {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (CO2FZSCONFIG.version != version) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Anscheinend stimmt etwas mit deiner Version nicht. Update die App oder versuche es später erneut",
                textAlign: TextAlign.center,
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    // FirebaseAuth.instance.signOut();
    if (!_routesLoaded && loadingAttempt < 4) {
      loadRoutes();
    }

    if (_isLoading || user.firstname == "none") {
      print("USER OBJECT: ${user.lastName}");
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 75),
              child: Text(
                "Startseite",
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .orderBy("totalPoints", descending: true)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  int indexUser = 0;
                  snapshot.data!.docs.asMap().entries.map((entry) {
                    int entryKey = entry.key;
                    var entryValue = entry.value.data();
                    print("DOCS" + entryValue.toString());
                    if (entryValue["uid"] == user.uid) {
                      indexUser = entryKey;
                    }
                  });

                  return Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: primaryColor,
                          child: Text("${indexUser}"))
                    ],
                  );
                }),
            // StreamBuilder(
            //   stream:
            //       FirebaseFirestore.instance.collection("users").snapshots(),
            //   builder: (context,
            //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     var docs = snapshot.data!.docs;

            //     List<model.User> users =
            //         docs.map((e) => model.User.fromSnap(e)).toList();

            //     int carCount = users
            //         .where((element) => element.transport == "Auto")
            //         .length;
            //     int ptCount = users
            //         .where((element) => element.transport == "ÖPNV")
            //         .length;
            //     int bicycleCount = users
            //         .where((element) => element.transport == "Fahrrad")
            //         .length;
            //     int walkCount = users
            //         .where((element) => element.transport == "Zu Fuß")
            //         .length;

            //     List<Map<String, int>> transportListCount = [
            //       {
            //         "Auto": carCount,
            //       },
            //       {
            //         "ÖPNV": ptCount,
            //       },
            //       {
            //         "Fahrrad": bicycleCount,
            //       },
            //       {
            //         "Zu Fuß": walkCount,
            //       }
            //     ];

            //     //  List<charts.Series<Map<String, int>, String>> series = [charts.Series(id: "transport", data: transportListCount, domainFn: (Map<String, int>, _))]

            //     return Text("");

            //     // return charts.PieChart();
            //   },
            // ),
            (!weekEnd && routesToday < 2)
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: InkWell(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        isScrollControlled: true,
                        useRootNavigator: true,
                        builder: (_) => AddRouteScreen(),
                      ),
                      child: DottedBorder(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: primaryColor,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Du hast heute noch keinen oder erst einen Eintrag gemacht.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  "Hier klicken um einen hinzuzufügen",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                ),
                              ]),
                        ),
                        radius: const Radius.circular(10),
                        borderType: BorderType.RRect,
                        strokeWidth: 3,
                        dashPattern: [10, 6],
                        color: Colors.grey,
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 15),
              child: Text(
                "Neuigkeiten",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("articles")
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ArticleInfoRowCard(
                        article: Article.fromSnap(snapshot.data!.docs[index])),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            Row(),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "Die besten Schüler",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            RankingStream(
              activeRanking: "Schüler",
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .orderBy("totalPoints", descending: true)
                  .where("role", isEqualTo: "user")
                  .limit(3)
                  .snapshots(),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "Die besten Klassen",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            RankingStream(
              activeRanking: "Klassen",
              stream: FirebaseFirestore.instance
                  .collection("admin")
                  .doc(user.schoolIdBlank)
                  .collection("classes")
                  .orderBy("totalPoints", descending: true)
                  .limit(3)
                  .snapshots(),
            ),
            Row(),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 20),
              child: Text(
                "Die beste Schule",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
            RankingStream(
              activeRanking: "Schulen",
              stream: FirebaseFirestore.instance
                  .collection("admin")
                  .orderBy("totalPoints", descending: true)
                  .limit(1)
                  .snapshots(),
            ),
          ],
        ),
      ),
    )
        // body: StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        //     builder: (context,
        //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return const Center(child: CircularProgressIndicator());
        //       }

        //       return ListView.builder(
        //         itemCount: snapshot.data!.docs.length,
        //         itemBuilder: (context, index) =>
        //             PostCard(snap: snapshot.data!.docs[index].data()),
        //       );
        //     }),
        );
  }
}
