import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/route.dart' as model;
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

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

  deleteRoute(String userId, String routeId) async {
    try {
      String res = await FirestoreMethods().deleteRoute(userId, routeId);
      if (res == "success") {
        Navigator.of(context).pop();
        return;
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void loadLocation(String locationId, bool startLocationState) async {
    var res = await FirestoreMethods().catchLocation(
      locationId: locationId,
    );
    if (res == "Undefined Error" || res is String) {
      showSnackBar(context, res);
      return loadLocation(locationId, startLocationState);
    } else {
      if (startLocationState) {
        startLocation = Location.fromSnap(res);
        setState(() {
          _locationLoaded1 = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    if (_locationLoaded1) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
          backgroundColor: primaryColor,
          actions: [
            !widget.otherProfileState
                ? IconButton(
                    icon: Icon(Icons.delete, color: lightRed),
                    onPressed: () => deleteRoute(
                      user.uid,
                      widget.route.id,
                    ),
                  )
                : Container()
          ],
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text("VON"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: AutoSizeText(
                            startLocation!.name,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("NACH"),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: AutoSizeText(
                            widget.route.endAddress,
                            style: Theme.of(context).textTheme.headline3,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Icon(Icons.bike_scooter, size: 100, color: primaryColor)
              ],
            ),
          ),
        ),
      );
    } else {
      loadLocation(widget.route.startAddress, true);
      // loadLocation(widget.route.endAddress, false);
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
