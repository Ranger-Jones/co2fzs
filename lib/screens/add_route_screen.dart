import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/contest.dart';
import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/user.dart';
import 'package:co2fzs/providers/contest_provider.dart';
import 'package:co2fzs/providers/school_class_provider.dart';
import 'package:co2fzs/providers/school_provider.dart';
import 'package:co2fzs/providers/user_provider.dart';
import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/screens/profile_screen.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/dimensions.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/auth_button.dart';
import 'package:co2fzs/widgets/image_button.dart';
import 'package:co2fzs/widgets/text_field_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddRouteScreen extends StatefulWidget {
  AddRouteScreen({Key? key}) : super(key: key);

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  final TextEditingController _distanceController = TextEditingController();
  String startAddress = "";
  String endAddress = "";

  bool isChecked = false;
  bool _isLoading = false;

  int _contestLoadingAttempt = 0;

  School? school;
  Contest? contest;
  DateTime startDate =
      (DateTime.now().weekday == 6 || DateTime.now().weekday == 7)
          ? DateTime.now().subtract(const Duration(days: 2))
          : DateTime.now();

  Location location1 = Location.getEmptyLocation();
  Location location2 = Location.getEmptyLocation();

  bool _schoolLoaded = false;
  bool _contestLoaded = false;
  bool _locationLoaded = false;

  int addingStep = 0;

  @override
  void initState() {
    super.initState();
  }

  Map<String, bool> checkedVehicle = {
    "walk": false,
    "car": true,
    "pt": false,
    "bicycle": false
  };
  String selectedVehicle = "car";
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _distanceController.dispose();
  }

  void loadSchool() async {
    User user = Provider.of<UserProvider>(context, listen: false).getUser;
    setState(() {
      _isLoading = true;
    });
    var res = await FirestoreMethods().catchSchool(
      schoolId: user.schoolId,
    );
    if (res == "Undefined Error" ||
        res == "SchulID ist inkorrekt" ||
        res is String) {
      // showSnackBar(context, res);
      loadSchool();
    } else {
      school = School(
        schoolId: res["schoolId"],
        id: res["id"],
        schoolname: res["schoolname"],
        location: res["location"],
        classes: res["classes"],
        totalPoints: double.parse("${res["totalPoints"]}"),
        users: res["users"],
        contestId: res["contestId"],
      );
      setState(() {
        _schoolLoaded = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void loadContest() async {
    User user = Provider.of<UserProvider>(context, listen: false).getUser;
    setState(() {
      _isLoading = true;
      _contestLoadingAttempt++;
    });

    if (_contestLoadingAttempt > 5) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    var res = await FirestoreMethods().catchContest(
      contestId: user.contestId,
    );
    if (res == "Undefined Error" || res is String) {
      // showSnackBar(context, res);
      return loadContest();
    } else {
      contest = Contest.fromSnap(res);
    }

    setState(() {
      _contestLoaded = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  void loadLocations() async {
    User user = Provider.of<UserProvider>(context, listen: false).getUser;
    setState(() {
      _isLoading = true;
      _contestLoadingAttempt++;
    });

    var res = await FirestoreMethods().catchLocation(
      locationId: user.homeAddress,
    );
    if (res == "Undefined Error" || res is String) {
      // showSnackBar(context, res);
      return loadLocations();
    } else {
      location1 = Location.fromSnap(res);
    }

    if (user.homeAddress2 != "") {
      var res = await FirestoreMethods().catchLocation(
        locationId: user.homeAddress2,
      );
      if (res == "Undefined Error" || res is String) {
        // showSnackBar(context, res);
        return loadLocations();
      } else {
        location2 = Location.fromSnap(res);
      }
    }

    setState(() {
      _locationLoaded = true;
    });

    setState(() {
      _isLoading = false;
    });
  }

  void uploadRoute(String schoolIdBlank, String schoolClassId) async {
    setState(() {
      _isLoading = true;
    });

    if (startDate == null) {
      showSnackBar(context, "Bitte wähle ein Datum aus");
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Location selectedLocation;

    if (startAddress == location1.name) {
      selectedLocation = location1;
    } else {
      selectedLocation = location2;
    }

    String res = await FirestoreMethods().uploadRoute(
      startAddress: startAddress,
      endAddress: endAddress,
      driveBack: isChecked,
      transport: selectedVehicle,
      date: startDate,
      schoolIdBlank: schoolIdBlank,
      classId: schoolClassId,
    );
    if (res == "Success") {
      // Navigator.of(context).pop(
      //   MaterialPageRoute(
      //     builder: (_) => ProfileScreen(),
      //   ),
      // );
      showSnackBar(context, "Erfolgreich hochgeladen");
      await Provider.of<UserProvider>(context, listen: false).refreshUser();
      _distanceController.text = "";

      isChecked = false;
    } else {
      showSnackBar(context, res);
    }
    Navigator.pop(context);
    setState(() {
      _isLoading = false;
    });
  }

  void selectVehicle(String name) {
    selectedVehicle = name;

    checkedVehicle.updateAll((key, value) => false);
    setState(() {
      checkedVehicle.update(name, (value) => true);
    });
  }

  void increaseAddingStep() {
    setState(() {
      addingStep++;
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return secondaryColor;
    }
    return blueColor;
  }

  List<Widget> buildAddingStep(User user) {
    switch (addingStep) {
      case 0:
        return [
          ModalDivider(),
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Wie bist du heute zur Schule gekommen?",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ImageButton(
              transport_option: walk,
              onTap: () => selectVehicle("walk"),
              selected: checkedVehicle["walk"]!,
              onDoubleTap: () {
                selectVehicle("walk");
                increaseAddingStep();
              },
            ),
            ImageButton(
              transport_option: bicycle,
              onTap: () => selectVehicle("bicycle"),
              selected: checkedVehicle["bicycle"]!,
              onDoubleTap: () {
                selectVehicle("bicycle");
                increaseAddingStep();
              },
            ),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButton(
                transport_option: pt,
                onTap: () => selectVehicle("pt"),
                selected: checkedVehicle["pt"]!,
                onDoubleTap: () {
                  increaseAddingStep();
                  selectVehicle("pt");
                },
              ),
              ImageButton(
                transport_option: car,
                onTap: () => selectVehicle("car"),
                selected: checkedVehicle["car"]!,
                onDoubleTap: () {
                  selectVehicle("car");
                  increaseAddingStep();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ];
      case 1:
        return [
          ModalDivider(),
          AuthButton(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: contest!.startDate.toDate(),
                maxTime: DateTime.now(),
                onChanged: (date) {
                  setState(() {
                    if (startDate.weekday == 6 || startDate.weekday == 7) {
                      startDate = contest!.startDate.toDate();
                    } else {
                      startDate = date;
                    }
                  });
                },
                onConfirm: (date) {
                  setState(() {
                    if (startDate.weekday == 6 || startDate.weekday == 7) {
                      startDate = contest!.startDate.toDate();
                    } else {
                      startDate = date;
                    }
                  });
                },
                currentTime:
                    (DateTime.now().weekday == 6 || DateTime.now().weekday == 7)
                        ? contest!.startDate.toDate()
                        : DateTime.now(),
                locale: LocaleType.de,
              );
            },
            label: startDate == null
                ? "Select Date"
                : DateFormat.yMMMMd().format(startDate),
          ),
          SizedBox(
            height: 20,
          ),
          user.homeAddress2 != "" && user.homeAddress != user.homeAddress2
              ? DropdownButton<String>(
                  value: startAddress,
                  icon: const Icon(Icons.arrow_downward, color: primaryColor),
                  elevation: 16,
                  style: Theme.of(context).textTheme.bodyText2,
                  isExpanded: true,
                  alignment: Alignment.center,
                  underline: Container(
                    height: 2,
                    color: blueColor,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      startAddress = newValue!;
                    });
                  },
                  items: [location1.name, location2.name]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              : Text(
                  "Heimatadresse: ${location1.name}",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.start,
                ),
          SizedBox(height: 16),
          Text(
            "Schuladresse: ${school!.location}",
            style: Theme.of(context).textTheme.headline3,
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rückfahrt?",
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.start,
              ),
              Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(
                    () {
                      isChecked = value!;
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          AuthButton(
            onTap: () {
              uploadRoute(user.schoolIdBlank, user.classId);
            },
            label: "Eintrag speichern",
            isLoading: _isLoading,
          ),
          SizedBox(
            height: 20,
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    //Contest contest = Provider.of<ContestProvider>(context).getContest;
    User user = Provider.of<UserProvider>(context).getUser;

    // SchoolClass schoolClass =
    //     Provider.of<SchoolClassProvider>(context).getSchoolClass;

    if (startAddress == "") {
      startAddress = user.homeAddress;
    }

    if (!_schoolLoaded) {
      loadSchool();
    }

    if (!_locationLoaded) {
      loadLocations();
    }

    if (!_contestLoaded && _contestLoadingAttempt < 5) {
      loadContest();
    }

    initializeDateFormatting();
    Intl.defaultLocale = 'de_DE';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Container(
          width: double.infinity,
          child: !_isLoading
              ? ((_contestLoadingAttempt > 5)
                  ? Text("Kein Wettbewerb")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildAddingStep(user),
                    ))
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class ModalDivider extends StatelessWidget {
  const ModalDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(children: [
        SizedBox(height: 20),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 10,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}
