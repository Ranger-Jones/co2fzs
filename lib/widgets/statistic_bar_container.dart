import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticBarContainer extends StatefulWidget {
  final DateTime date;
  final double totalPoints;
  final double dailyPoints;
  const StatisticBarContainer({
    Key? key,
    required this.date,
    required this.totalPoints,
    required this.dailyPoints,
  }) : super(key: key);

  @override
  State<StatisticBarContainer> createState() => _StatisticBarContainerState();
}

class _StatisticBarContainerState extends State<StatisticBarContainer> {
  @override
  Widget build(BuildContext context) {
    double _barHeight = MediaQuery.of(context).size.height * 0.34;
    double factorHeight = (widget.dailyPoints / widget.totalPoints);
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            height: _barHeight,
            child: FractionallySizedBox(
              heightFactor: factorHeight,
              widthFactor: 1.0,
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
              ),
            ),
          ),
          Text(
            DateFormat("E").format(widget.date).toString()[0],
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
