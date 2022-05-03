import 'package:cloud_firestore/cloud_firestore.dart';


class SchoolBuilding {
  final String id;
  final String buildingName;
  final classes;
  final users;
  final String location;
  final double totalPoints;
  final String photoUrl;

  SchoolBuilding({
    required this.id,
    required this.buildingName,
    required this.location,
    required this.classes,
    required this.totalPoints,
    required this.users,
    this.photoUrl = "",
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "buildingName": buildingName,
        "location": location,
        "classes": classes,
        "totalPoints": totalPoints,
        "users": users,
        "totalPoints": totalPoints,
      };

  static SchoolBuilding fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SchoolBuilding(
      id: snapshot["id"],
      buildingName: snapshot["buildingName"],
      location: snapshot["location"],
      classes: snapshot["classes"],
      users: snapshot["users"],
      totalPoints: double.parse("${snapshot["totalPoints"]}"),
    );
  }
}
