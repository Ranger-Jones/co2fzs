import 'package:auto_size_text/auto_size_text.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/widgets/table_item.dart';
import 'package:flutter/material.dart';

class ClassDetailScreen extends StatelessWidget {
  final SchoolClass schoolClass;
  const ClassDetailScreen({Key? key, required this.schoolClass}) : super(key: key);

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
                  schoolClass.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline2,
                  maxLines: 2,
                ),
                SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TableItem(info: schoolClass.name, label: "Adresse"),
                      TableItem(
                          info: "${schoolClass.users.length}", label: "Schüler"),
                      TableItem(
                          info: "${schoolClass.users.length}", label: "Klassen"),
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
