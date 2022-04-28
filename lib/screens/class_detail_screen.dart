import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/ranking_list_info.dart';
import 'package:co2fzs/widgets/table_item.dart';
import 'package:flutter/material.dart';

class ClassDetailScreen extends StatelessWidget {
  final SchoolClass schoolClass;
  const ClassDetailScreen({Key? key, required this.schoolClass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 64),
                AutoSizeText(
                  schoolClass.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline4,
                  maxLines: 2,
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TableItem(info: schoolClass.name, label: "Adresse"),
                      TableItem(
                          info: "${schoolClass.users.length}",
                          label: "Registrierte Mitglieder"),
                      TableItem(
                          info: "${schoolClass.userCount}",
                          label: "Insgesamte Mitglieder"),
                      TableItem(
                          info: "${schoolClass.totalPoints.toStringAsFixed(2)}",
                          label: "Punkte Insgesamt"),
                      TableItem(
                          info: (schoolClass.totalPoints /
                                  schoolClass.users.length)
                              .toStringAsFixed(2),
                          label: "Punkte im Durchschnitt"),
                      SizedBox(height: 12),
                      Text(
                        "Klassenmitglieder",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 12),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("classId", isEqualTo: schoolClass.id)
                            .where("activated", isEqualTo: true)
                            .where("disqualified", isEqualTo: false)
                            .orderBy("totalPoints", descending: true)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          return ListView.builder(
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => Column(
                              children: [
                                RankingListInfo(
                                  snap:
                                      User.fromSnap(snapshot.data!.docs[index]),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
