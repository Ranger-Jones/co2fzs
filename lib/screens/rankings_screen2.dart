import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/screens/ranking_filter_screen.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/filter_button.dart';
import 'package:co2fzs/widgets/icon_button_colored.dart';
import 'package:co2fzs/widgets/ranking_list_info.dart';
import 'package:co2fzs/widgets/search_field.dart';
import 'package:co2fzs/widgets/text_field_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({Key? key}) : super(key: key);

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  var currentDataStream =
      FirebaseFirestore.instance.collection("posts").snapshots();

  TextEditingController _searchFieldController = TextEditingController();

  List<String> rankingOptions = [
    "Alle Schüler deiner Schule",
    "Schulen",
    "Klassen",
    "Deine Klasse",
    "Fahrrad",
    "ÖPNV",
    "zu Fuß",
  ];
  String activeRanking = "Alle";
  String activeCategory = "Alle";

  SchoolClass? schoolClass;

  bool _isLoading = true;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    _searchFieldController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRightStream(value: activeRanking);
  }

  void getRightStream(
      {required String value, String schoolId = "", String classId = ""}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> currentDataStreamInline;
    switch (value) {
      case "Schulen":
        currentDataStreamInline = _firestoreInstance
            .collection("admin")
            .orderBy(
              "totalPoints",
              descending: true,
            )
            .snapshots();
        break;
      case "Fahrrad":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("transport", isEqualTo: "Fahrrad")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "ÖPNV":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("transport", isEqualTo: "ÖPNV")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "zu Fuß":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("transport", isEqualTo: "Zu Fuß")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "Auto":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("transport", isEqualTo: "Auto")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "Klassen":
        currentDataStreamInline = _firestoreInstance
            .collection("admin")
            .doc(schoolId)
            .collection("classes")
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "Deine Klasse":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("classId", isEqualTo: classId)
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "Search":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("role", isEqualTo: "user")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "Alle":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("role", isEqualTo: "user")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      default:
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("schoolIdBlank", isEqualTo: schoolId)
            .where("role", isEqualTo: "user")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
    }
    setState(() {
      currentDataStream = currentDataStreamInline;
      activeRanking = value;
      _isLoading = false;
    });
  }

  void setActiveRanking(String newRanking) {
    setState(() {
      activeCategory = newRanking;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(
      context,
    ).getUser;

    if (_isLoading || user.username == "none") {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (activeRanking == "Alle") {
      getRightStream(
        value: "Alle",
        schoolId: user.schoolIdBlank,
        classId: user.classId,
      );
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: Row(
                mainAxisAlignment: kIsWeb
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: kIsWeb
                        ? MediaQuery.of(context).size.width * 0.35
                        : MediaQuery.of(context).size.width * 0.75,
                    child: SearchField(
                      controller: _searchFieldController,
                      helperText: "Suche nach Personen",
                      label: "Suchen",
                      onChanged: () =>
                          //  getRightStream(
                          //   value: _searchFieldController.text.isEmpty
                          //       ? "Alle"
                          //       : "Search",
                          //   classId: user.classId,
                          //   schoolId: user.schoolIdBlank,
                          // ),
                          setActiveRanking("Suche"),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        (kIsWeb ? 0.025 : 0.15),
                    height: MediaQuery.of(context).size.width *
                        (kIsWeb ? 0.025 : 0.15),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: primaryColor,
                    ),
                    child: IconButton(
                      splashRadius: 10,
                      icon: const Icon(
                        Icons.filter_alt_rounded,
                      ),
                      onPressed: () => showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return RankingFilterScreen(
                              refresh: getRightStream,
                              classId: user.classId,
                              schoolId: user.schoolIdBlank,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: kIsWeb
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                IconButtonColored(
                  data: Icons.people,
                  label: "Alle",
                  onPressed: () => getRightStream(
                    value: "Alle",
                    classId: user.classId,
                    schoolId: user.schoolIdBlank,
                  ),
                  color: secondaryColor,
                  active: activeRanking == "Alle",
                ),
                IconButtonColored(
                    label: "Klassen",
                    data: Icons.class_,
                    onPressed: () => getRightStream(
                          value: "Klassen",
                          classId: user.classId,
                          schoolId: user.schoolIdBlank,
                        ),
                    color: lightRed,
                    active: activeRanking == "Klassen"),
                IconButtonColored(
                    data: Icons.school,
                    label: "Schulen",
                    onPressed: () => getRightStream(
                          value: "Schulen",
                          classId: user.classId,
                          schoolId: user.schoolIdBlank,
                        ),
                    color: lightPurple,
                    active: activeRanking == "Schulen"),
              ],
            ),
            StreamBuilder(
              stream: currentDataStream,
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      width: double.infinity,
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 6),
                          Text("Daten werden verarbeitet..."),
                        ],
                      ),
                    ),
                  );
                }

                List<Map> schoolPoints = [];
                List<Map> schoolClassPoints = [];
                List<Map> searchedUser = [];

                int itemListLength = 0;

                int userIndex = 0;

                bool useOtherSetup = false;

                if (activeRanking == "Schulen") {
                  snapshot.data!.docs.forEach((e) {
                    School _school = School.fromSnap(e);
                    double averagePoints =
                        (_school.users.length > 0 && _school.totalPoints > 0)
                            ? (_school.totalPoints / _school.users.length)
                            : 0;
                    schoolPoints.add(
                        {"averagePoints": averagePoints, "school": _school});
                  });
                  itemListLength = schoolPoints.length;
                  schoolPoints.sort((sc1, sc2) {
                    var r =
                        sc2["averagePoints"].compareTo(sc1["averagePoints"]);
                    if (r != 0) return r;
                    return sc1["school"]
                        .schoolname
                        .compareTo(sc2["school"].schoolname);
                  });
                  useOtherSetup = true;
                  print("SCHOOLPOINTSLIST ${schoolPoints.toString()}");
                } else if (activeRanking == "Klassen") {
                  snapshot.data!.docs.forEach((e) {
                    SchoolClass _schoolClass = SchoolClass.fromSnap(e);
                    double averagePoints = _schoolClass.userCount > 0
                        ? (_schoolClass.totalPoints / _schoolClass.userCount)
                        : 0;
                    schoolClassPoints.add({
                      "averagePoints": averagePoints,
                      "schoolClass": _schoolClass
                    });
                  });
                  itemListLength = schoolClassPoints.length;
                  schoolClassPoints.sort((sc1, sc2) {
                    var r =
                        sc2["averagePoints"].compareTo(sc1["averagePoints"]);
                    if (r != 0) return r;
                    return sc1["schoolClass"]
                        .name
                        .compareTo(sc2["schoolClass"].name);
                  });
                  useOtherSetup = true;
                  print(
                      "SCHOOL|CLASS|POINTS|LIST ${schoolClassPoints.toString()}");
                } else {
                  itemListLength = snapshot.data!.docs.length;
                }

                if (activeRanking != "Klassen" &&
                    activeRanking != "Schulen" &&
                    _searchFieldController.text.isNotEmpty) {
                  String _searchValue = _searchFieldController.text;
                  print(snapshot.data!.docs);
                  double _similarityLowestValue = 0.4;
                  snapshot.data!.docs.forEach((e) {
                    User user = User.fromSnap(e);
                    userIndex++;
                    double _similarityFirstName =
                        StringSimilarity.compareTwoStrings(
                      user.firstname,
                      _searchValue,
                    );
                    double _similarityLastName =
                        StringSimilarity.compareTwoStrings(
                      user.lastName,
                      _searchValue,
                    );
                    double _similarityUserName =
                        StringSimilarity.compareTwoStrings(
                      user.username,
                      _searchValue,
                    );
                    print(
                        "SIMILARITY FIRSTNAME ${_similarityFirstName} | ${user.firstname} | ${_searchValue}");
                    if (_similarityFirstName > _similarityLowestValue ||
                        _similarityLastName > _similarityLowestValue ||
                        _similarityUserName > _similarityLowestValue) {
                      searchedUser.add({"user": user, "index": userIndex});
                    }
                  });
                  itemListLength = searchedUser.length;
                }

                return itemListLength > 0
                    ? ListView.builder(
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itemListLength,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Column(
                          children: [
                            RankingListInfo(
                              snap: useOtherSetup
                                  ? (schoolClassPoints.isNotEmpty
                                      ? schoolClassPoints[index]["schoolClass"]
                                      : schoolPoints[index]["school"])
                                  : searchedUser.isNotEmpty
                                      ? searchedUser[index]["user"]
                                      : getRightDataType(
                                          snapshot.data!.docs[index],
                                          activeRanking,
                                        ),
                              index: searchedUser.isNotEmpty
                                  ? searchedUser[index]["index"]
                                  : index + 1,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 24),
                        child: Text("Keine Daten verfügbar"));
              },
            ),
          ],
        ),
      ),
    );
  }
}
