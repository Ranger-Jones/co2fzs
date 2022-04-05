import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }

  print("No image selected");
}

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: Theme.of(context).textTheme.bodyText2),
      backgroundColor: Colors.white,
    ),
  );
}

dynamic getRightDataType(var snapshot, String activeRanking) {
  switch (activeRanking) {
    case "Schulen":
      print("SNAPSHOT SCHULE ${snapshot["schoolId"]}");
      return School.fromSnap(snapshot);

    case "Klassen":
      return SchoolClass.fromSnap(snapshot);
    case "Deine Klasse":
      return User.fromSnap(snapshot);
    case "Alle Schüler":
      return User.fromSnap(snapshot);
    default:
      return User.fromSnap(snapshot);
  }
}
