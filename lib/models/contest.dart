import 'package:cloud_firestore/cloud_firestore.dart';

class Contest {
  final String title;
  final startDate;
  final endDate;
  final String id;
  final schools;

  Contest({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.schools,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "startDate": startDate,
        "endDate": endDate,
        "schools": schools,
        "id": id,
      };

  static Contest fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Contest(
      title: snapshot["title"],
      startDate: snapshot["startDate"],
      endDate: snapshot["endDate"],
      schools: snapshot["schools"],
      id: snapshot["id"],
    );
  }
}
