import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/post.dart';
import 'package:co2fzs/models/route.dart';
import 'package:co2fzs/models/transport_option.dart';
import 'package:co2fzs/resources/storage_methods.dart';
import 'package:co2fzs/utils/dimensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> catchSchool({required int schoolId}) async {
    String res = "Undefined Error";
    try {
      var schools = await _firestore
          .collection("admin")
          .where("schoolId", isEqualTo: schoolId)
          .get();
      var school;

      if (schools.size <= 0 || schools.size > 1) {
        res = "SchulID ist inkorrekt";
        return res;
      } else {
        school = schools.docs[0];
        return school;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<dynamic> catchRoutes({required String uid}) async {
    String res = "Undefined Error";
    try {
      var routes = await _firestore
          .collection("users")
          .doc(uid)
          .collection("routes")
          .get();

      if (routes.docs.length == 0) {
        res = "Keine Einträge";
        return res;
      } else {
        return routes.docs;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteRoute({
    required String userId,
    required String routeId,
    required String schoolIdBlank,
    required String classId,
    required double points,
  }) async {
    String res = "Undefined Error";

    try {
      await _firestore
          .collection("users")
          .doc(userId)
          .collection("routes")
          .doc(routeId)
          .delete();
      await _firestore
          .collection("users")
          .doc(userId)
          .update({"totalPoints": FieldValue.increment(-points)});

      await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .update({"totalPoints": FieldValue.increment(points)});

      await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .collection("classes")
          .doc(classId)
          .update({"totalPoints": FieldValue.increment(points)});
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<dynamic> catchContest({required String contestId}) async {
    String res = "Undefined Error";
    try {
      DocumentSnapshot contestSnap =
          await _firestore.collection("contest").doc(contestId).get();

      return contestSnap;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<dynamic> catchLocation({
    required String locationId,
  }) async {
    String res = "Undefined Error";
    try {
      DocumentSnapshot locationSnap =
          await _firestore.collection("locations").doc(locationId).get();

      return locationSnap;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<dynamic> routesToday() async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    dynamic res = "Undefined Error";
    try {
      QuerySnapshot userRoutes = await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("routes")
          .get();
      int routes = 0;
      userRoutes.docs.forEach((doc) {
        if (doc["date"] != null) {
          {
            if (DateFormat.yMMMMd().format(DateTime.now()).toString() ==
                DateFormat.yMMMMd().format(doc["date"].toDate()).toString()) {
              routes++;
            }
          }
        }
      });
      res = routes;
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> uploadRoute({
    required String startAddress,
    required String endAddress,
    required bool driveBack,
    required String transport,
    required date,
    required String schoolIdBlank,
    required String classId,
  }) async {
    User currentUser = FirebaseAuth.instance.currentUser!;
    String res = "Undefined Error";
    QuerySnapshot userRoutes = await _firestore
        .collection("users")
        .doc(currentUser.uid)
        .collection("routes")
        .where("driveBack", isEqualTo: driveBack)
        .get();
    bool alreadyExists = false;

    List<Route> routes = userRoutes.docs.map((e) => Route.fromSnap(e)).toList();

    int carCount = routes.where((element) => element.transport == "car").length;
    int ptCount = routes.where((element) => element.transport == "pt").length;
    int bicycleCount =
        routes.where((element) => element.transport == "bicycle").length;
    int walkCount =
        routes.where((element) => element.transport == "walk").length;

    Map<String, int> transportListCount = {
      "Auto": carCount,
      "ÖPNV": ptCount,
      "Fahrrad": bicycleCount,
      "Zu Fuß": walkCount,
    };

    int largestValue = 0;
    String mostUsedTransport = "Auto";

    transportListCount.forEach((key, value) {
      if (value > largestValue) {
        largestValue = value;
        mostUsedTransport = key;
      }
    });

    _firestore
        .collection("users")
        .doc(currentUser.uid)
        .update({"transport": mostUsedTransport});

    userRoutes.docs.forEach((doc) {
      if (doc["date"] != null) {
        {
          if (DateFormat.yMMMMd().format(date).toString() ==
              DateFormat.yMMMMd().format(doc["date"].toDate()).toString()) {
            alreadyExists = true;
          }
        }
      }
    });
    if (alreadyExists) {
      res = "Ein Eintrag mit dieser Konfiguration existiert bereits";
      return res;
    }

    double points = 0;
    TransportOption? transportOption = transportationMap[transport];

    try {
      String routeId = const Uuid().v1();

      final locationRes =
          await _firestore.collection("locations").doc(startAddress).get();
      Location location = Location.fromSnap(locationRes);

      points = location.distanceFromSchool * transportOption!.scoreMultiplier;
      Route route = Route(
        date: date,
        distance: location.distanceFromSchool,
        driveBack: driveBack,
        endAddress: endAddress,
        points: points,
        startAddress: startAddress,
        id: routeId,
        transport: transport,
        datePublished: DateTime.now(),
        dateUpdated: DateTime.now(),
      );
      _firestore
          .collection("users")
          .doc(currentUser.uid)
          .collection("routes")
          .doc(routeId)
          .set(
            route.toJson(),
          );
      await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .update({"totalPoints": FieldValue.increment(points)});

      await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .update({"totalPoints": FieldValue.increment(points)});

      await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .collection("classes")
          .doc(classId)
          .update({"totalPoints": FieldValue.increment(points)});
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> catchConfig() async {
    String res = "Undefined Error";
    try {
      final res = await _firestore.collection("config").doc("STATIC").get();
      return res["version"];
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<dynamic> catchClasses({required String schoolIdBlank}) async {
    String res = "Undefined Error";
    try {
      QuerySnapshot classesSnapshots = await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .collection("classes")
          .get();

      if (classesSnapshots.docs.length < 1) {
        res =
            "Deine Schule ist noch nicht eingerichtet. Bitte habe etwas geduld ;)";
        return res;
      } else {
        return classesSnapshots.docs;
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<dynamic> catchClass(
      {required String schoolIdBlank, required String classId}) async {
    String res = "Undefined Error";
    try {
      var res = await _firestore
          .collection("admin")
          .doc(schoolIdBlank)
          .collection("classes")
          .doc(classId)
          .get();

      return res;
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some Error";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        username: username,
        description: description,
        postId: postId,
        postUrl: photoUrl,
        uid: uid,
        datePublished: DateTime.now(),
        likes: [],
        profImage: profImage,
      );
      _firestore.collection("posts").doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "name": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection("posts").doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }
}
