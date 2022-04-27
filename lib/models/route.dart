import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final date;
  final bool driveBack;
  final double points;
  final double distance;
  final String startAddress;
  final String endAddress;
  final String transport;
  final datePublished;
  final dateUpdated;

  Route({
    required this.date,
    required this.distance,
    required this.driveBack,
    required this.endAddress,
    required this.points,
    required this.startAddress,
    required this.id,
    required this.transport,
    required this.datePublished,
    required this.dateUpdated,
  });

  static Route emptyRoute() => Route(
        date: DateTime.now(),
        distance: 0,
        driveBack: false,
        endAddress: "",
        points: 0,
        startAddress: "",
        id: "",
        transport: "",
        datePublished: DateTime.now(),
        dateUpdated: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "id": id,
        "distance": distance,
        "driveBack": driveBack,
        "endAddress": endAddress,
        "points": points,
        "startAddress": startAddress,
        "transport": transport,
        "datePublished": datePublished,
        "dateUpdated": dateUpdated,
      };

  static Route fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Route(
      date: snapshot["date"],
      id: snapshot["id"],
      endAddress: snapshot["endAddress"],
      points: double.parse("${snapshot["points"]}"),
      startAddress: snapshot["startAddress"],
      distance: double.parse("${snapshot["distance"]}"),
      driveBack: snapshot["driveBack"],
      transport: snapshot["transport"],
      dateUpdated: snapshot["dateUpdated"],
      datePublished: snapshot["datePublished"],
    );
  }
}
