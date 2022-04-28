import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String name;
  final double distanceFromSchool;
  final String photoUrl;
  final datePublished;
  final dateUpdated;
  final String id;

  Location({
    required this.name,
    required this.datePublished,
    required this.dateUpdated,
    required this.distanceFromSchool,
    required this.photoUrl,
    required this.id,
  });

  static Location getEmptyLocation() {
    return Location(
      name: "",
      datePublished: DateTime.now(),
      dateUpdated: DateTime.now(),
      distanceFromSchool: 0,
      photoUrl: "",
      id: "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "datePublished": datePublished,
        "dateUpdated": dateUpdated,
        "distanceFromSchool": distanceFromSchool,
        "id": id,
        "photoUrl": photoUrl,
      };

  static Location fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Location(
      name: snapshot["name"],
      datePublished: snapshot["datePublished"],
      dateUpdated: snapshot["dateUpdated"],
      distanceFromSchool: double.parse("${snapshot["distanceFromSchool"]}"),
      id: snapshot["id"],
      photoUrl: snapshot["photoUrl"],
    );
  }
}
