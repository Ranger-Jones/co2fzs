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
  photoUrl:
      "https://images.unsplash.com/photo-1519255122284-c3acd66be602?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2Fsa3xlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  userCounter: 0,
);

final TransportOption bicycle = TransportOption(
  name: "Fahrrad",
  scoreMultiplier: 2.5,
  photoUrl:
      "https://images.unsplash.com/photo-1574965234283-2f20a4cffa43?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OXx8YmljeWNsZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  userCounter: 0,
);

final TransportOption pt = TransportOption(
  name: "ÖPNV",
  scoreMultiplier: 1,
  photoUrl:
      "https://images.unsplash.com/photo-1503776470087-3569342b4a2e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTJ8fHRyYWlufGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60",
  userCounter: 0,
);

final TransportOption car = TransportOption(
  name: "Auto",
  scoreMultiplier: 0,
  photoUrl:
      "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
  userCounter: 0,
);

final Map<String, TransportOption> transportationMap = {
  "car": car,
  "pt": pt,
  "bicycle": bicycle,
  "walk": walk
};
