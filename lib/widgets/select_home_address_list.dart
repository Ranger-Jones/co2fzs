import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/home_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectHomeAddress extends StatefulWidget {
  final String classId;
  final String schoolId;
  final Function setLocation;
  final Function setLocation2;
  final Location location1;
  final Location location2;
  SelectHomeAddress({
    Key? key,
    required this.classId,
    required this.schoolId,
    required this.setLocation,
    required this.setLocation2,
    required this.location1,
    required this.location2,
  }) : super(key: key);

  @override
  State<SelectHomeAddress> createState() => _SelectHomeAddressState();
}

class _SelectHomeAddressState extends State<SelectHomeAddress> {
  final List<Location> selectedLocations = [
    Location.getEmptyLocation(),
    Location.getEmptyLocation(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.location1.id != "") {
      selectedLocations[0] = widget.location1;
    }

    if (widget.location2.id != "") {
      selectedLocations[1] = widget.location2;
    }
  }

  selectLocation(Location location) {
    bool locationRemove = false;

    if (location.id == selectedLocations[0].id) {
      locationRemove = true;
      if (selectedLocations[1].id == "") {
        setState(() {
          selectedLocations[0] = Location.getEmptyLocation();
        });

        widget.setLocation(Location.getEmptyLocation());
      } else {
        widget.setLocation(selectedLocations[1]);
        widget.setLocation2(Location.getEmptyLocation());
        setState(() {
          selectedLocations[0] = selectedLocations[1];
          selectedLocations[1] = Location.getEmptyLocation();
        });
      }
    } else if (location.id == selectedLocations[1].id) {
      setState(() {
        selectedLocations[1] = Location.getEmptyLocation();
      });
      locationRemove = true;
      widget.setLocation2(Location.getEmptyLocation());
    }

    if (!locationRemove) {
      if (selectedLocations[0].id == "") {
        widget.setLocation(location);
        setState(() {
          selectedLocations[0] = location;
        });
      } else if (selectedLocations[1].id == "") {
        widget.setLocation2(location);
        setState(() {
          selectedLocations[1] = location;
        });
      } else {
        Location tmpLoc = selectedLocations[1];
        widget.setLocation(tmpLoc);
        widget.setLocation2(location);
        setState(() {
          selectedLocations[0] = tmpLoc;
          selectedLocations[1] = location;
        });
      }
    }

    selectedLocations.forEach((element) {
      print("2: ${element.name}");
    });
    //Navigator.pop(context);

    print("SELECTED LOCATIONS ${selectedLocations.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    // User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 24,
        ),
        child: Column(
          children: [
            (selectedLocations[0].name != "" || selectedLocations[1].name != "")
                ? Row(
                    children: [
                      Text("Ausgewählt: ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          "${selectedLocations[0].name != "" ? selectedLocations[0].name : ""}, ${selectedLocations[1].name != "" ? selectedLocations[1].name : ""}")
                    ],
                  )
                : Text("Keine Orte ausgewählt"),
            SizedBox(height: 16),
            Divider(),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("locations")
                  .where(
                    "schoolIdBlank",
                    isEqualTo: widget.schoolId,
                  )
                  .orderBy("distanceFromSchool", descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs
                      .map((e) => InkWell(
                            onTap: () => selectLocation(
                              Location.fromSnap(
                                e,
                              ),
                            ),
                            child: HomeInfo(
                              location: Location.fromSnap(
                                e,
                              ),
                              selectedLocations: selectedLocations,
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
