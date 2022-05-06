import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:co2fzs/models/location.dart';
import 'package:co2fzs/models/school.dart';
import 'package:co2fzs/models/schoolClass.dart';
import 'package:co2fzs/models/school_building.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/widgets/auth_button.dart';
import 'package:co2fzs/widgets/select_home_address_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/responsive/mobile_screen_layout.dart';
import 'package:co2fzs/responsive/responsive_layout_screen.dart';
import 'package:co2fzs/responsive/web_screen_layout.dart';
import 'package:co2fzs/screens/login_screen.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _schoolClassController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _homeAddressController = TextEditingController();
  final TextEditingController _homeAddress2Controller = TextEditingController();

  String schoolClass = "";
  String schoolBuilding = "";
  String schoolBuildingId = "";
  Uint8List? _image;

  bool _isLoading = false;
  bool _isLoadingScreen = false;
  int registrationStep = 1;

  List<String> classNames = [];
  List<SchoolClass> schoolClasses = [];
  List<SchoolBuilding> schoolBuildings = [];

  late School school;
  Location location1 = Location.getEmptyLocation();
  Location location2 = Location.getEmptyLocation();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _schoolClassController.dispose();
    _schoolIdController.dispose();
    _usernameController.dispose();
    _homeAddressController.dispose();
    _homeAddress2Controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSampleImage();
  }

  void getSampleImage() async {
    _image = (await rootBundle.load("assets/images/Download.jpg"))
        .buffer
        .asUint8List();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    int _emailLength = _emailController.text.length;
    if (_emailController.text.contains(" ")) {
      showSnackBar(context, "Entferne das Leerzeichen hinter deiner Mail.");
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (location1.name == "") {
      showSnackBar(context, "Bitte wähle eine Heimatadresse aus");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      firstname: _firstnameController.text,
      lastname: _lastnameController.text,
      schoolClass: schoolClass,
      schoolId: int.parse(_schoolIdController.text),
      file: _image!,
      homeAddress: location1.id,
      homeAddress2: location2.id,
      classId: schoolClasses
          .where((element) => element.name == schoolClass)
          .toList()[0],
    );
    setState(() {
      _isLoading = false;
    });
    if (res != "success") {
      showSnackBar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  catchClasses() async {
    var res = await FirestoreMethods().catchClasses(
      schoolIdBlank: school.id,
    );

    if (res is String) {
      showSnackBar(context, res);
    } else {
      res.forEach((element) => schoolClasses.add(SchoolClass(
            name: element["name"],
            totalPoints: double.parse("${element["totalPoints"]}"),
            schoolIdBlank: element["schoolIdBlank"],
            users: element["users"],
            id: element["id"],
            userCount: element["userCount"],
          )));

      // res.forEach(
      //     (element) => schoolClasses.add(SchoolClass.fromSnap(element)));

      schoolClasses.forEach((element) => classNames.add(element.name));

      setState(() {
        schoolClass = schoolClasses[0].name;
        registrationStep++;
      });
    }
  }

  void increaseRegistrationStep() async {
    if (registrationStep == 1) {
      setState(() {
        _isLoading = true;
      });
      if (_schoolIdController.text != "") {
        var res = await FirestoreMethods().catchSchool(
          schoolId: int.parse(_schoolIdController.text),
        );
        if (res == "Undefined Error" ||
            res == "SchulID ist inkorrekt" ||
            res is String) {
          showSnackBar(context, res);
        } else {
          school = School.fromSnap(res);
          // catchClasses();
          loadSchoolBuildings();
          // await Future.delayed(Duration(milliseconds: 5000));

        }
      } else {
        showSnackBar(context, "Bitte alle Felder ausfüllen!");
      }
    } else if (registrationStep == 2) {
      setState(() {
        _isLoadingScreen = true;
      });

      loadClasses();
      setState(() {
        _isLoadingScreen = false;
        registrationStep++;
      });
    } else if (registrationStep == 3) {
      setState(() {
        _isLoading = true;
      });
      if (_firstnameController.text != "" &&
          _lastnameController.text != "" &&
          (schoolClass != null || schoolClass != "")) {
        registrationStep++;
      } else {
        showSnackBar(context, "Bitte fülle alle Felder aus");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  loadSchoolBuildings() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var res = await FirestoreMethods().catchBuildings(
        schoolIdBlank: school.id,
      );

      if (res is String) {
        showSnackBar(context, res);
      } else {
        res.forEach(
            (element) => schoolBuildings.add(SchoolBuilding.fromSnap(element)));
        setState(() {
          schoolBuilding = schoolBuildings[0].buildingName;
          schoolBuildingId = schoolBuildings[0].id;
        });
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      _isLoading = false;
      registrationStep++;
      if (schoolBuilding == "") {
        loadClasses();
        registrationStep++;
      }
    });
  }

  loadClasses() async {
    List<SchoolClass> _classes = [];
    setState(() {
      _isLoadingScreen = true;
      schoolClasses = [];
      classNames = [];
    });

    SchoolBuilding? _schoolBuilding;

    List<dynamic> classIds = [];
    try {
      if (schoolBuildingId.isNotEmpty) {
        if (school.id != schoolBuildingId) {
          _schoolBuilding = schoolBuildings
              .firstWhere((element) => schoolBuildingId == element.id);
          classIds = _schoolBuilding.classes;
        } else {
          classIds = school.classes.map((element) => element).toList();
          schoolBuildings.forEach(
            (schoolBuilding) => schoolBuilding.classes.forEach((classId) {
              classIds.remove(
                classId,
              );
              print(classId);
            }),
          );
        }
      } else {
        classIds = school.classes;
      }

      print(classIds);
      setState(() {
        _isLoadingScreen = true;
      });
      _classes = await FirestoreMethods().catchClassesPrototype(
        schoolIdBlank: school.id,
        classIds: classIds,
        context: context,
      );
      setState(() {
        _isLoadingScreen = true;
      });
      await Future.delayed(Duration(milliseconds: 1800));
      _classes.removeWhere((element) => element.name == "");

      classNames = _classes.map((element) => element.name).toList();

      print(_classes);

      await Future.delayed(Duration(milliseconds: 800))
          .then((value) => setState(() {
                schoolClass = classNames[0];
                _isLoadingScreen = false;
              }));
    } catch (e) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showSnackBar(context, e.toString());
      });
    }

    setState(() {
      _isLoadingScreen = false;

      schoolClasses = _classes;
    });
  }

  setLocation(Location newValue) {
    setState(() {
      location1 = newValue;
    });
  }

  setLocation2(Location newValue) {
    setState(() {
      location2 = newValue;
    });
  }

  List<Widget> buildRegistrationSite() {
    switch (registrationStep) {
      case 1:
        return [
          const SizedBox(height: 24),
          TextFieldInput(
            hintText: "Schul ID",
            textInputType: TextInputType.number,
            textEditingController: _schoolIdController,
          ),
          const SizedBox(height: 24),
          AuthButton(
            onTap: increaseRegistrationStep,
            label: "Weiter",
            isLoading: _isLoading,
          )
        ];
      case 2:
        if (schoolBuildings == []) {
          setState(() {
            registrationStep++;
          });
        }
        List<DropdownMenuItem<String>> buildingDropDownList = schoolBuildings
            .map<DropdownMenuItem<String>>((SchoolBuilding value) {
          return DropdownMenuItem<String>(
            value: value.id,
            child: Text(value.buildingName),
          );
        }).toList();
        buildingDropDownList.add(DropdownMenuItem<String>(
          value: school.id,
          child: Text(school.schoolname),
        ));
        return [
          const SizedBox(height: 64),
          Text(
            "Anscheinend besitzt deine Schule mehrere Gebäude. Bitte wähle ein Gebäude aus.",
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButton<String>(
            value: schoolBuildingId,
            icon: const Icon(Icons.arrow_downward, color: primaryColor),
            elevation: 16,
            style: Theme.of(context).textTheme.bodyText2,
            isExpanded: true,
            alignment: Alignment.center,
            underline: Container(
              height: 2,
              color: primaryColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                schoolBuildingId = newValue!;
              });
            },
            items: buildingDropDownList,
          ),
          const SizedBox(height: 24),
          AuthButton(
            onTap: increaseRegistrationStep,
            label: "Weiter",
            isLoading: _isLoading,
          ),
          const SizedBox(height: 24),
        ];
      case 3:
        if (classNames == []) {
          loadClasses();
          return [
            Center(child: CircularProgressIndicator()),
          ];
        }
        return [
          TextFieldInput(
            hintText: "Vorname",
            textInputType: TextInputType.text,
            textEditingController: _firstnameController,
          ),
          const SizedBox(height: 24),
          TextFieldInput(
            hintText: "Nachname",
            textInputType: TextInputType.text,
            textEditingController: _lastnameController,
          ),
          const SizedBox(height: 24),
          Container(
            width: MediaQuery.of(context).size.width,
            child: DropdownButton<String>(
              value: schoolClass,
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
                  schoolClass = newValue!;
                });
              },
              items: classNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          AuthButton(
            onTap: increaseRegistrationStep,
            label: "Weiter",
            isLoading: _isLoading,
          ),
          // const SizedBox(height: 24),
          // AuthButton(
          //   onTap: () => setState(() {
          //     registrationStep--;
          //   }),
          //   label: "Zurück",
          //   color: lightRed,
          //   isLoading: _isLoading,
          // )
        ];
      case 4:
        return [
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1635324236775-868d3680b65f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8ZWxvbiUyMG11c2t8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
                      ),
                    ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: const Icon(
                    Icons.add_a_photo,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          TextFieldInput(
            hintText: "Username",
            textInputType: TextInputType.text,
            textEditingController: _usernameController,
          ),
          const SizedBox(height: 24),
          AuthButton(
              onTap: () => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    isScrollControlled: true,
                    useRootNavigator: true,
                    builder: (_) {
                      SchoolClass schoolClassItem = schoolClasses.firstWhere(
                        (element) => element.name == schoolClass,
                      );

                      return Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: SelectHomeAddress(
                          classId: schoolClassItem.id,
                          schoolId: schoolBuildingId.isEmpty
                              ? school.id
                              : schoolBuildingId,
                          setLocation: setLocation,
                          setLocation2: setLocation2,
                          location1: location1,
                          location2: location2,
                        ),
                      );
                    },
                  ),
              label: (location1.name == "" && location2.name == "")
                  ? "Wohnort hinzufügen"
                  : "${location1.name}, ${location2.name}"),
          const SizedBox(height: 24),
          TextFieldInput(
            hintText: "Email",
            textInputType: TextInputType.emailAddress,
            textEditingController: _emailController,
          ),
          const SizedBox(height: 24),
          TextFieldInput(
            hintText: "Passwort",
            textInputType: TextInputType.text,
            textEditingController: _passwordController,
            isPass: true,
          ),

          const SizedBox(height: 24),
          AuthButton(
            onTap: signUpUser,
            label: "Registrieren",
            isLoading: _isLoading,
          ),
          const SizedBox(height: 24),
          AuthButton(
            onTap: () => setState(() {
              registrationStep--;
            }),
            label: "Zurück",
            color: lightRed,
            isLoading: _isLoading,
          )
          // Flexible(child: Container(), flex: 2),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //         child: const Text("Already have an account? "),
          //         padding: const EdgeInsets.symmetric(vertical: 8)),
          //     GestureDetector(
          //       onTap: navigateToLogin,
          //       child: Container(
          //           child: const Text("Log In!",
          //               style: TextStyle(fontWeight: FontWeight.bold)),
          //           padding: const EdgeInsets.symmetric(vertical: 8)),
          //     )
          //   ],
          // )
        ];
      case 5:
        return [Text("rf")];
      default:
        return [Text("rf")];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !_isLoadingScreen
            ? SingleChildScrollView(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 60),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildRegistrationSite(),
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
