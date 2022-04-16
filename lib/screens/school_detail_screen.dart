import 'package:auto_size_text/auto_size_text.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/widgets/table_item.dart';
import 'package:flutter/material.dart';

class SchoolDetailScreen extends StatelessWidget {
  final School school;
  const SchoolDetailScreen({Key? key, required this.school}) : super(key: key);

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
                  school.schoolname,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                  maxLines: 2,
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TableItem(info: school.location, label: "Adresse"),
                      TableItem(info: "${school.users.length}", label: "Schüler"),
                      TableItem(info: "${school.classes.length}", label: "Klassen"),
                      TableItem(info: "${school.schoolId}", label: "Schul ID"),
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
