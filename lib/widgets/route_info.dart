import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/widgets/route_detail.dart';
import 'package:flutter/material.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class RouteInfo extends StatefulWidget {
  final model.Route route;
  final bool otherProfileState;
  const RouteInfo(
      {Key? key, required this.route, this.otherProfileState = false})
      : super(key: key);

  @override
  State<RouteInfo> createState() => _RouteInfoState();
}

class _RouteInfoState extends State<RouteInfo> {
  IconData _iconData = Icons.do_not_disturb_on_total_silence_rounded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRightItem();
  }

  void getRightItem() {
    switch (widget.route.transport) {
      case "car":
        _iconData = Icons.airport_shuttle_outlined;
        break;
      case "pt":
        _iconData = Icons.train_sharp;
        break;
      case "bicycle":
        _iconData = Icons.pedal_bike;
        break;
      default:
        _iconData = Icons.directions_walk;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    Intl.defaultLocale = 'de_DE';
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => RouteDetail(
            route: widget.route,
          ),
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryColor,
              child: Icon(
                _iconData,
                color: Colors.white,
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Text(
              "${widget.route.points.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.headline3,
            ),
            widget.route.driveBack ? Icon(Icons.arrow_back) : SizedBox(),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${widget.route.distance} km",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  DateFormat("d. MMMM").format(widget.route.date.toDate()),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
