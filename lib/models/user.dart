import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final int schoolId;
  final String email;
  final String uid;
  final int operationLevel;
  final String schoolIdBlank;
  final String role;
  final String grade;
  final String photoUrl;
  final String firstname;
  final String lastName;
  final double totalPoints;
  final String homeAddress;
  final String homeAddress2;
  final bool disqualified;
  final String classId;
  final String contestId;
  final String transport;
  final datePublished;
  final dateUpdated;
  final bool activated;
  final friends;

  const User({
    required this.username,
    required this.email,
    required this.uid,
    required this.schoolId,
    required this.operationLevel,
    required this.schoolIdBlank,
    required this.firstname,
    required this.lastName,
    required this.grade,
    required this.photoUrl,
    required this.role,
    required this.totalPoints,
    required this.homeAddress,
    required this.homeAddress2,
    required this.disqualified,
    required this.classId,
    required this.contestId,
    required this.transport,
    required this.activated,
    required this.datePublished,
    required this.dateUpdated,
    required this.friends,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "schoolId": schoolId,
        "schoolIdBlank": schoolIdBlank,
        "operationLevel": operationLevel,
        "firstname": firstname,
        "lastName": lastName,
        "grade": grade,
        "photoUrl": photoUrl,
        "role": role,
        "totalPoints": totalPoints,
        "homeAddress": homeAddress,
        "homeAddress2": homeAddress2,
        "disqualified": disqualified,
        "classId": classId,
        "contestId": contestId,
        "transport": transport,
        "datePublished": datePublished,
        "dateUpdated": dateUpdated,
        "activated": activated,
        "friends": friends,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      operationLevel: snapshot["operationLevel"],
      schoolId: snapshot["schoolId"],
      email: snapshot["email"],
      uid: snapshot["uid"],
      schoolIdBlank: snapshot["schoolIdBlank"],
      firstname: snapshot["firstname"],
      lastName: snapshot["lastName"],
      role: snapshot["role"],
      photoUrl: snapshot["photoUrl"],
      grade: snapshot["grade"],
      totalPoints: double.parse("${snapshot["totalPoints"]}"),
      homeAddress: snapshot["homeAddress"],
      homeAddress2: snapshot["homeAddress2"],
      disqualified: snapshot["disqualified"],
      classId: snapshot["classId"],
      contestId: snapshot["contestId"],
      transport: snapshot["transport"] ?? "Auto",
      activated: snapshot["activated"],
      datePublished: snapshot["datePublished"],
      dateUpdated: snapshot["dateUpdated"],
      friends: snapshot["friends"],
    );
  }
}
