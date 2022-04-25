import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/filter_button.dart';
import 'package:co2fzs/widgets/ranking_list_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  List<String> rankingOptions = [
    "Alle Schüler deiner Schule",
    "Schulen",
    "Klassen",
    "Deine Klasse",
    "Fahrrad",
    "ÖPNV",
    "zu Fuß",
  ];
  String activeRanking = "Alle Schüler deiner Schule";

  bool _isLoading = true;

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
            .where("transport", isEqualTo: "Fahrrad")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "ÖPNV":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
            .where("transport", isEqualTo: "ÖPNV")
            .where("activated", isEqualTo: true)
            .where("disqualified", isEqualTo: false)
            .orderBy("totalPoints", descending: true)
            .snapshots();
        break;
      case "zu Fuß":
        currentDataStreamInline = _firestoreInstance
            .collection("users")
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

      case "Alle Schüler deiner Schule":
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

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, top: 75),
                child: Text(
                  "Ranking",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  primary: false,
                  shrinkWrap: true,
                  children: rankingOptions
                      .map(
                        (e) => FilterButton(
                          label: e,
                          onTap: getRightStream,
                          schoolId: user.schoolIdBlank,
                          classId: user.classId,
                          activeRanking: activeRanking,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              // DropdownButton<String>(
              //   value: activeRanking,
              //   icon: const Icon(Icons.arrow_downward, color: primaryColor),
              //   elevation: 16,
              //   style: Theme.of(context).textTheme.bodyText2,
              //   isExpanded: true,
              //   alignment: Alignment.center,
              //   underline: Container(
              //     height: 2,
              //     color: blueColor,
              //   ),
              //   onChanged: (String? newValue) {
              //     getRightStream(
              //       value: newValue!,
              //       classId: user.classId,
              //       schoolId: user.schoolIdBlank,
              //     );
              //   },
              //   items:
              //       rankingOptions.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child:
              //           Text(value, style: Theme.of(context).textTheme.bodyText2),
              //     );
              //   }).toList(),
              // ),
              StreamBuilder(
                stream: currentDataStream,
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Column(
                      children: [
                        RankingListInfo(
                          snap: getRightDataType(
                              snapshot.data!.docs[index], activeRanking),
                          index: index + 1,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
