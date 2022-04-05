import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final Function onTap;
  final String classId;
  final String schoolId;
  final String activeRanking;
  const FilterButton({
    Key? key,
    required this.label,
    required this.onTap,
    required this.classId,
    required this.schoolId,
    required this.activeRanking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(
        value: label,
        classId: classId,
        schoolId: schoolId,
      ),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: label == activeRanking ? primaryColor : secondaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 15,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
