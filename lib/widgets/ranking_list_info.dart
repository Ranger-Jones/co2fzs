import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingListInfo extends StatefulWidget {
  final snap;
  final int index;
  RankingListInfo({
    Key? key,
    required this.snap,
    required this.index,
  }) : super(key: key);

  @override
  State<RankingListInfo> createState() => _RankingListInfoState();
}

class _RankingListInfoState extends State<RankingListInfo> {
  String type = "School";
  School? school;
  SchoolClass? schoolClass;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRightType();
  }

  void getRightType() {
    if (widget.snap is School) {
      type = "School";
      school = widget.snap;
    } else if (widget.snap is SchoolClass) {
      type = "SchoolClass";
      schoolClass = widget.snap;
    } else if (widget.snap is User) {
      type = "User";
      user = widget.snap;
    }
  }

  Widget buildRightInfo() {
    switch (type) {
      case "User":
        return RankingListRow(
            index: widget.index,
            name: user!.firstname,
            points: double.parse(user!.totalPoints.toStringAsFixed(2)));
      case "School":
        return RankingListRow(
            index: widget.index,
            name: school!.schoolname,
            points: double.parse(school!.totalPoints.toStringAsFixed(2)));
      case "SchoolClass":
        print(schoolClass!.totalPoints.toStringAsFixed(2));
        return RankingListRow(
            index: widget.index,
            name: schoolClass!.name,
            points: double.parse(schoolClass!.totalPoints.toStringAsFixed(2)));

      default:
        return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Column(
        children: [
          buildRightInfo(),
          Divider(),
        ],
      ),
    );
  }
}

class RankingListRow extends StatelessWidget {
  final int index;
  final String name;
  final double points;
  const RankingListRow({
    Key? key,
    required this.index,
    required this.name,
    required this.points,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          child: Text(
            "${index}",
            style: Theme.of(context).textTheme.headline3,
          ),
          radius: ((MediaQuery.of(context).size.height * 0.1) / 3),
          backgroundColor: primaryColor,
        ),
        Flexible(child: Container(), flex: 1),
        SizedBox(
          child: Text(
            name,
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(child: Container(), flex: 1),
        SizedBox(
          child: Text(
            points.toStringAsFixed(2),
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
