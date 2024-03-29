import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/ranking_list_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingStream extends StatefulWidget {
  final stream;
  final String activeRanking;

  RankingStream({
    Key? key,
    required this.stream,
    required this.activeRanking,
  }) : super(key: key);

  @override
  State<RankingStream> createState() => _RankingStreamState();
}

class _RankingStreamState extends State<RankingStream> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(
      context,
    ).getUser;
    return StreamBuilder(
        stream: widget.stream,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (user.firstname == "none") {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.length == 0) {
            return const Center(child: Text("Keine Daten verfügbar"));
          }
          List<Map> schoolClassPoints = [];
          bool useOtherSetup = false;
          int itemListLength = 0;

          if (widget.activeRanking == "Klassen") {
            snapshot.data!.docs.forEach((e) {
              SchoolClass _schoolClass = SchoolClass.fromSnap(e);
              double averagePoints = _schoolClass.users.length > 0
                  ? (_schoolClass.totalPoints / _schoolClass.users.length)
                  : 0;
              schoolClassPoints.add({
                "averagePoints": averagePoints,
                "schoolClass": _schoolClass
              });
            });
            itemListLength = schoolClassPoints.length - 1;
            schoolClassPoints.sort((sc1, sc2) {
              var r = sc2["averagePoints"].compareTo(sc1["averagePoints"]);
              if (r != 0) return r;
              return sc1["schoolClass"].name.compareTo(sc2["schoolClass"].name);
            });
            useOtherSetup = true;
          } else {
            itemListLength = snapshot.data!.docs.length;
          }

          return ListView.builder(
            itemCount: itemListLength,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            primary: false,
            itemBuilder: (context, index) => RankingListInfo(
              snap: useOtherSetup
                  ? schoolClassPoints[index]["schoolClass"]
                  : getRightDataType(
                      snapshot.data!.docs[index], widget.activeRanking),
              index: index + 1,
            ),
          );
        });
  }
}
