import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteDetail extends StatefulWidget {
  final model.Route route;
  static String routeName = "/route-detail";
  final bool otherProfileState;

  RouteDetail({Key? key, required this.route, this.otherProfileState = false})
      : super(key: key);

  @override
  State<RouteDetail> createState() => _RouteDetailState();
}

class _RouteDetailState extends State<RouteDetail> {
  Location? startLocation;

  Location? endLocation;

  bool _locationLoaded1 = false;
  bool _locationLoaded2 = false;

  // @override
  // void initState() {
  //   super.initState();
  //   loadLocation(widget.route.startAddress, true);
  //   loadLocation(widget.route.endAddress, false);
  // }

  // deleteRoute() {}

  void loadLocation(String locationId, bool startLocationState) async {
    var res = await FirestoreMethods().catchLocation(
      locationId: locationId,
    );
    if (res == "Undefined Error" || res is String) {
      // showSnackBar(context, res);
      return loadLocation(locationId, startLocationState);
    } else {
      if (startLocationState) {
        startLocation = Location.fromSnap(res);

        _locationLoaded1 = true;
      } else {
        endLocation = Location.fromSnap(res);

        _locationLoaded2 = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locationLoaded1 && _locationLoaded2) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
          backgroundColor: primaryColor,
          actions: [
            // !widget.otherProfileState
            //     ? IconButton(
            //         icon: Icon(Icons.delete, color: lightRed),
            //         onPressed: () => deleteRoute())
            //     : Container()
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 64),
                Text(
                  "${widget.route.points}",
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 10),
                Text(
                  "Punkte",
                  style: Theme.of(context).textTheme.headline3,
                ),
                // Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Column(
                //         children: [
                //           Text("VON"),
                //           Text(
                //             startLocation!.name,
                //             style: Theme.of(context).textTheme.headline3,
                //           )
                //         ],
                //       ),
                //       Column(
                //         children: [
                //           Text("NACH"),
                //           Text(
                //             endLocation!.name,
                //             style: Theme.of(context).textTheme.headline3,
                //           )
                //         ],
                //       )
                //     ]),
              ],
            ),
          ),
        ),
      );
    } else {
      loadLocation(widget.route.startAddress, true);
      loadLocation(widget.route.endAddress, false);
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
