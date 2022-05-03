import 'package:co2fzs/providers/contest_provider.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/screens/rankings_screen2.dart';
import 'package:co2fzs/utils/config.dart';
import 'package:co2fzs/widgets/route_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/responsive/mobile_screen_layout.dart';
import 'package:co2fzs/responsive/responsive_layout_screen.dart';
import 'package:co2fzs/responsive/web_screen_layout.dart';
import 'package:co2fzs/screens/login_screen.dart';
import 'package:co2fzs/screens/signup_screen.dart';
import 'package:co2fzs/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: CO2FZSCONFIG.options,
    );
  } else {
    await Firebase.initializeApp();
  }
  //FirebaseAuth.instance.signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ChangeNotifierProvider(create: (_) => SchoolProvider()),
        // ChangeNotifierProvider(create: (_) => SchoolClassProvider()),
        // ChangeNotifierProvider(create: (_) => ContestProvider()),
      ],
      child: MaterialApp(
        title: 'CO2fzs',
        theme: ThemeData().copyWith(
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 34,
              fontFamily: "Rubik",
              color: textColor,
            ),
            headline2: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              fontFamily: "Rubik",
              color: textColor,
            ),
            headline3: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              fontFamily: "Rubik",
              color: textColor,
            ),
            headline4: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 50,
              fontFamily: "Rubik",
              color: textColor,
            ),
            bodyText1: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16,
              fontFamily: "Rubik",
              color: textColor,
            ),
            bodyText2: TextStyle(
              fontSize: 18,
              color: textColor,
            ),
          ),
        ),
        initialRoute: "/",
        routes: {
          "/ranking": (context) => RankingsScreen(),
        },
        // home: const ResponsiveLayout(
        //   webScreenLayout: WebScreenLayout(),
        //   mobileScreenLayout: MobileScreenLayout(),
        // ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    webScreenLayout: WebScreenLayout(),
                    mobileScreenLayout: MobileScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return LoginScreen();
            }),
      ),
    );
  }
}
