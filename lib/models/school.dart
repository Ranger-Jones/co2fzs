import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/SchoolClass.dart';
import 'package:co2fzs/models/user.dart';

class School {
  final int schoolId;
  final String id;
  final String schoolname;
  final classes;
  final users;
  final String location;
  final double totalPoints;
  final String contestId;
  final String photoUrl;
  final int totalUserCount;

  School({
    required this.schoolId,
    required this.id,
    required this.schoolname,
    required this.location,
    required this.classes,
    required this.totalPoints,
    required this.users,
    required this.contestId,
    this.photoUrl = "",
    required this.totalUserCount,
  });

  Map<String, dynamic> toJson() => {
        "schoolId": schoolId,
        "id": id,
        "schoolname": schoolname,
        "location": location,
        "classes": classes,
        "totalPoints": totalPoints,
        "users": users,
        "totalPoints": totalPoints,
        "contestId": contestId,
        "totalUserCount": totalUserCount,
      };

  static School fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return School(
      schoolId: snapshot["schoolId"],
      id: snapshot["id"],
      schoolname: snapshot["schoolname"],
      location: snapshot["location"],
      classes: snapshot["classes"],
      users: snapshot["users"],
      totalPoints: double.parse("${snapshot["totalPoints"]}"),
      contestId: snapshot["contestId"],
      totalUserCount: int.parse("${snapshot["totalUserCount"] ?? 0}"),
    );
  }
}
