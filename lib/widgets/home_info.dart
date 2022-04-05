import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class HomeInfo extends StatelessWidget {
  final Location location;
  final List<Location> selectedLocations;

  const HomeInfo({
    Key? key,
    required this.location,
    required this.selectedLocations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    if (selectedLocations[0].id == location.id ||
        selectedLocations[1].id == location.id) {
      bgColor = primaryColor;
    }
    return Container(
        color: bgColor,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(location.name),
              Text(
                "${location.distanceFromSchool}",
              )
            ],
          ),
          SizedBox(height: 16),
          Divider()
        ]));
  }
}
