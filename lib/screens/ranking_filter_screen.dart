import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class RankingFilterScreen extends StatefulWidget {
  final Function refresh;
  final String classId;
  final String schoolId;
  const RankingFilterScreen({
    Key? key,
    required this.refresh,
    required this.classId,
    required this.schoolId,
  }) : super(key: key);

  @override
  State<RankingFilterScreen> createState() => _RankingFilterScreenState();
}

class _RankingFilterScreenState extends State<RankingFilterScreen> {
  String activeCategory = "Alle";
  bool yourClass = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Wrap(
        children: [
          // ListTile(
          //   title: Text(
          //     'Punkte',
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyText2!
          //         .copyWith(fontWeight: FontWeight.bold),
          //   ),
          //   trailing: Container(
          //     width: MediaQuery.of(context).size.width * 0.4,
          //     child: DropdownButton<String>(
          //       value: "Insgesamt",
          //       icon: const Icon(Icons.arrow_downward, color: primaryColor),
          //       elevation: 16,
          //       style: Theme.of(context).textTheme.bodyText2,
          //       isExpanded: true,
          //       alignment: Alignment.center,
          //       underline: Container(
          //         height: 2,
          //         color: primaryColor,
          //       ),
          //       onChanged: (String? newValue) {
          //         // setState(() {
          //         //   newValue = newValue!;
          //         // });
          //       },
          //       items: ["Insgesamt", "Im Durchschnitt"]
          //           .map<DropdownMenuItem<String>>((String value) {
          //         return DropdownMenuItem<String>(
          //           value: value,
          //           child: Text(value),
          //         );
          //       }).toList(),
          //     ),
          //   ),
          // ),
          ListTile(
            title: Text(
              'Kategorie',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              child: DropdownButton<String>(
                value: activeCategory,
                icon: const Icon(Icons.arrow_downward, color: primaryColor),
                elevation: 16,
                style: Theme.of(context).textTheme.bodyText2,
                isExpanded: true,
                alignment: Alignment.center,
                underline: Container(
                  height: 2,
                  color: primaryColor,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    activeCategory = newValue!;
                  });
                  widget.refresh(
                    value: activeCategory,
                    classId: widget.classId,
                    schoolId: widget.schoolId,
                  );

                  // getRightStream(
                  //   value: _activeCategory,
                  //   classId: user.classId,
                  //   schoolId: user.schoolIdBlank,
                  // );
                },
                items: ["Fahrrad", "zu Fuß", "Alle", "ÖPNV"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Deine Klasse',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: Checkbox(
                value: yourClass,
                onChanged: (value) {
                  setState(() {
                    yourClass = value!;
                  });
                  if (yourClass) {
                    widget.refresh(
                      value: "Deine Klasse",
                      classId: widget.classId,
                      schoolId: widget.schoolId,
                    );
                  } else {
                    widget.refresh(
                      value: activeCategory,
                      classId: widget.classId,
                      schoolId: widget.schoolId,
                    );
                  }
                }),
          ),
          // ListTile(
          //   title: Text(
          //     'Title 4',
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
          // ListTile(
          //   title: Text(
          //     'Title 5',
          //     style: Theme.of(context).textTheme.bodyText2,
          //   ),
          // ),
        ],
      ),
    );
  }
}
