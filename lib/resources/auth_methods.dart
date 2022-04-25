import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/contest.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:co2fzs/models/user.dart' as model;
import 'package:co2fzs/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<dynamic> getUserDetails() async {
  //   String res = "Provider Error";
  //   try {
  //     User currentUser = _auth.currentUser!;

  //     DocumentSnapshot snap =
  //         await _firestore.collection("users").doc(currentUser.uid).get();
  //     model.User user = model.User.fromSnap(snap);
  //   } catch (e) {
  //     res = e.toString();
  //     return res;
  //   }

  //   return;
  // }

  // Future<dynamic> getContestDetails() async {
  //   User currentUser = _auth.currentUser!;
  //   Contest? contest;
  //   String res = "Contest Provider Error";
  //   try {
  //     DocumentSnapshot userSnap =
  //         await _firestore.collection("users").doc(currentUser.uid).get();

  //     model.User user = model.User.fromSnap(userSnap);

  //     DocumentSnapshot snap =
  //         await _firestore.collection("contest").doc(user.contestId).get();
  //     contest = Contest.fromSnap(snap);
  //   } catch (e) {
  //     res = e.toString();
  //     return res;
  //   }

  //   return contest;
  // }

  // Future<dynamic> getSchoolDetails() async {
  //   String res = "School Provider Error";
  //   School? school;
  //   try {
  //     User currentUser = _auth.currentUser!;
  //     DocumentSnapshot userSnap =
  //         await _firestore.collection("users").doc(currentUser.uid).get();

  //     model.User user = model.User.fromSnap(userSnap);

  //     DocumentSnapshot schoolSnap =
  //         await _firestore.collection("admin").doc(user.schoolIdBlank).get();

  //     school = School.fromSnap(schoolSnap);
  //   } catch (e) {
  //     res = e.toString();
  //     return res;
  //   }

  //   return school;
  // }

  // Future<dynamic> getSchoolClassDetails() async {
  //   User currentUser = _auth.currentUser!;
  //   String res = "School Class Provider";
  //   SchoolClass? schoolClass;
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection("users").doc(currentUser.uid).get();
  //     model.User user = model.User.fromSnap(snap);
  //     DocumentSnapshot schoolClassSnap = await _firestore
  //         .collection("admin")
  //         .doc(user.schoolIdBlank)
  //         .collection("classes")
  //         .doc(user.classId)
  //         .get();

  //     schoolClass = SchoolClass.fromSnap(schoolClassSnap);
  //   } catch (e) {
  //     res = e.toString();
  //     return res;
  //   }

  //   return schoolClass;
  // }

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    model.User user;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    user = model.User.fromSnap(snap);
    if (user.username == "none") {
      user = await getUserDetails();
    }
    return user;
  }

  Future<Contest> getContestDetails() async {
    User currentUser = _auth.currentUser!;
    Contest contest;
    DocumentSnapshot userSnap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    model.User user = model.User.fromSnap(userSnap);

    if (user.username != "none") {
      DocumentSnapshot snap =
          await _firestore.collection("contest").doc(user.contestId).get();

      contest = Contest.fromSnap(snap);
    } else {
      contest = await getContestDetails();
    }
    return contest;
  }

  Future<School> getSchoolDetails() async {
    User currentUser = _auth.currentUser!;
    School school;
    DocumentSnapshot userSnap =
        await _firestore.collection("users").doc(currentUser.uid).get();

    model.User user = model.User.fromSnap(userSnap);

    if (user.username != "none") {
      DocumentSnapshot schoolSnap =
          await _firestore.collection("admin").doc(user.schoolIdBlank).get();

      school = School.fromSnap(schoolSnap);
    } else {
      school = await getSchoolDetails();
    }

    return school;
  }

  Future<SchoolClass> getSchoolClassDetails() async {
    User currentUser = _auth.currentUser!;
    SchoolClass schoolClass;
    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser.uid).get();
    model.User user = model.User.fromSnap(snap);
    if (user.username != "none") {
      DocumentSnapshot schoolClassSnap = await _firestore
          .collection("admin")
          .doc(user.schoolIdBlank)
          .collection("classes")
          .doc(user.classId)
          .get();
      schoolClass = SchoolClass.fromSnap(schoolClassSnap);
    } else {
      schoolClass = await getSchoolClassDetails();
    }

    return schoolClass;
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String firstname,
    required String lastname,
    required String schoolClass,
    required Uint8List file,
    required int schoolId,
    required String homeAddress,
    required String homeAddress2,
    required SchoolClass classId,
  }) async {
    String res =
        "Es gab ein Problem. Möglicherweise ist deine Mail schon vergeben.";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          firstname.isNotEmpty ||
          lastname.isNotEmpty ||
          schoolClass.isNotEmpty ||
          schoolId > 1) {
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
        }

        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection("admin").doc(school["id"]).update({
          "users": FieldValue.arrayUnion([cred.user!.uid])
        });

        await _firestore
            .collection("admin")
            .doc(school["id"])
            .collection("classes")
            .doc(classId.id)
            .update({
          "users": FieldValue.arrayUnion([cred.user!.uid])
        });

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);

        model.User user = model.User(
            firstname: firstname,
            lastName: lastname,
            grade: schoolClass,
            operationLevel: 1,
            role: "user",
            schoolId: schoolId,
            schoolIdBlank: school["id"],
            totalPoints: 0,
            username: username,
            photoUrl: photoUrl,
            email: email,
            uid: cred.user!.uid,
            homeAddress: homeAddress,
            homeAddress2: homeAddress2,
            disqualified: false,
            classId: classId.id,
            contestId: school["contestId"],
            transport: "",
            activated: false,
            datePublished: DateTime.now(),
            dateUpdated: DateTime.now(),
            friends: []);
        await _firestore
            .collection(
              "users",
            )
            .doc(
              cred.user!.uid,
            )
            .set(
              user.toJson(),
            );
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == "invalid-email") {
        res =
            "Die Email stimmt nicht mit dem Email-Standard überein, möglicherweise stimmt der Domain-Anbieter nicht oder du hast ein Leerzeichen hinter die Mail gesetzt. Bitte überprüfe deine Mail und versuche es erneut!";
      } else if (err.code == "weak-password") {
        res =
            "Das Passwort erfüllt nicht die erforderlichen Sicherheits-Standards: mind. 6 Zeichen. Bitte versuche es erneut mit einem besseren Passwort.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the field!";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "This User isn't registered. Please check your email.";
      } else if (e.code == "wrong-password") {
        res = "Please check your password!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
