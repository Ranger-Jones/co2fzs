// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:co2fzs/models/contest.dart';
// import 'package:co2fzs/models/school.dart';
// import 'package:co2fzs/models/schoolClass.dart';
// import 'package:co2fzs/providers/school_class_provider.dart';
// import 'package:co2fzs/providers/school_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:co2fzs/models/user.dart' as model;
// import 'package:co2fzs/providers/user_provider.dart';
// import 'package:co2fzs/utils/colors.dart';
// import 'package:co2fzs/utils/dimensions.dart';

// class MobileScreenLayout extends StatefulWidget {
//   const MobileScreenLayout({Key? key}) : super(key: key);

//   @override
//   State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
// }

// class _MobileScreenLayoutState extends State<MobileScreenLayout> {
//   int _page = 4;
//   late PageController pageController;
//   model.User? user;
//   School? school;
//   SchoolClass? schoolClass;
//   Contest? contest;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     pageController = PageController();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     pageController.dispose();
//   }

//   void navigationTapped(int page) {
//     pageController.jumpToPage(page);
//   }

//   void onPageChanged(int page) {
//     setState(() {
//       _page = page;
//     });
//   }

//   // void refreshProviders() async {
//   //   await Provider.of<UserProvider>(context).refreshUser();
//   //   await Provider.of<SchoolProvider>(context).refreshSchool();
//   //   await Provider.of<SchoolClassProvider>(context).refreshSchoolClass();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     // user = Provider.of<UserProvider>(context).getUser;

//     // school = Provider.of<SchoolProvider>(
//     //   context,
//     // ).getSchool;
//     // schoolClass = Provider.of<SchoolClassProvider>(
//     //   context,
//     // ).getSchoolClass;

//     // if (schoolClass!.name == "none" ||
//     //     school!.schoolname == "none" ||
//     //     user!.username == "none") {
//     //   refreshProviders();
//     //   return Scaffold(
//     //     body: Container(
//     //       child: Center(
//     //         child: Image.asset("assets/images/logo.png",
//     //             width: MediaQuery.of(context).size.height * 0.8),
//     //       ),
//     //     ),
//     //   );
//     // }
//     return Scaffold(
//       body: PageView(
//         children: homeScreenItems,
//         physics: const NeverScrollableScrollPhysics(),
//         controller: pageController,
//         onPageChanged: onPageChanged,

//       ),
//       bottomNavigationBar: CupertinoTabBar(
//         currentIndex: _page,
//         height: 75,
        
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home,
//                 color: _page == 0 ? primaryColor : secondaryColor),
//             label: "",
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list_alt_sharp,
//                 color: _page == 1 ? primaryColor : secondaryColor),
//             label: "",
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: CircleAvatar(
//               child: Icon(Icons.add,
//                   color: _page == 2 ? primaryColor : secondaryColor),
//             ),
//             label: "",
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.newspaper,
//                 color: _page == 3 ? primaryColor : secondaryColor),
//             label: "",
//             backgroundColor: primaryColor,
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person,
//                 color: _page == 4 ? primaryColor : secondaryColor),
//             label: "",
//             backgroundColor: primaryColor,
//           ),
//         ],
//         onTap: navigationTapped,
//       ),
//     );
//   }
// }
