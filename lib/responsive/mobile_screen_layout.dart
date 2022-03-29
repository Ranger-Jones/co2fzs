import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/contest.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/screens/add_route_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:co2fzs/models/user.dart' as model;
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/dimensions.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 4;
  PersistentTabController? _controller;

  model.User? user;
  School? school;
  SchoolClass? schoolClass;
  Contest? contest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.square_list),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.add),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
        activeColorSecondary: CupertinoColors.white,
        onPressed: (_context) => showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          isScrollControlled: true,
          useRootNavigator: true,
          builder: (_) => AddRouteScreen(),
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.news_solid),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  // void refreshProviders() async {
  //   await Provider.of<UserProvider>(context).refreshUser();
  //   await Provider.of<SchoolProvider>(context).refreshSchool();
  //   await Provider.of<SchoolClassProvider>(context).refreshSchoolClass();
  // }

  @override
  Widget build(BuildContext context) {
    // user = Provider.of<UserProvider>(context).getUser;

    // school = Provider.of<SchoolProvider>(
    //   context,
    // ).getSchool;
    // schoolClass = Provider.of<SchoolClassProvider>(
    //   context,
    // ).getSchoolClass;

    // if (schoolClass!.name == "none" ||
    //     school!.schoolname == "none" ||
    //     user!.username == "none") {
    //   refreshProviders();
    //   return Scaffold(
    //     body: Container(
    //       child: Center(
    //         child: Image.asset("assets/images/logo.png",
    //             width: MediaQuery.of(context).size.height * 0.8),
    //       ),
    //     ),
    //   );
    // }
    return PersistentTabView(
      context,
      controller: _controller,
      screens: homeScreenItems(context),
      items: _navBarsItems(),

      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows:
          true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: const ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),

      screenTransitionAnimation: const ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle:
          NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}
