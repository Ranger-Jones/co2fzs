import 'package:co2fzs/models/transport_option.dart';
import 'package:co2fzs/screens/add_route_screen.dart';
import 'package:co2fzs/screens/news_screen.dart';
import 'package:co2fzs/screens/profile_screen.dart';
import 'package:co2fzs/screens/rankings_screen.dart';
import 'package:flutter/material.dart';
import 'package:co2fzs/screens/feed_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

const webScreenSize = 5000;

List<Widget> homeScreenItems(BuildContext context) {
  return [
    FeedScreen(),
    RankingsScreen(),
    AddRouteScreen(),
    NewsScreen(),
    ProfileScreen(),
  ];
}

final TransportOption walk = TransportOption(
  name: "Zu Fuß",
  scoreMultiplier: 10,
  photoUrl: "assets/images/Fußgänger.JPG",
  userCounter: 0,
);

final TransportOption bicycle = TransportOption(
  name: "Fahrrad",
  scoreMultiplier: 2.5,
  photoUrl: "assets/images/Fahrrad.JPG",
  userCounter: 0,
);

final TransportOption pt = TransportOption(
  name: "ÖPNV",
  scoreMultiplier: 1,
  photoUrl: "assets/images/ÖPNV.JPG",
  userCounter: 0,
);

final TransportOption car = TransportOption(
  name: "Auto",
  scoreMultiplier: 0,
  photoUrl: "assets/images/Auto.JPG",
  userCounter: 0,
);

final Map<String, TransportOption> transportationMap = {
  "car": car,
  "pt": pt,
  "bicycle": bicycle,
  "walk": walk
};
