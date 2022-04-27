import 'package:co2fzs/screens/forgot_password_screen.dart';
import 'package:co2fzs/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/responsive/mobile_screen_layout.dart';
import 'package:co2fzs/responsive/responsive_layout_screen.dart';
import 'package:co2fzs/responsive/web_screen_layout.dart';
import 'package:co2fzs/screens/signup_screen.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == "success") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(context, res);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
  }

  void navigateToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 44),
                  Image.asset(
                    "assets/images/logo.png",
                    height: 180,
                  ),
                  const SizedBox(height: 64),
                  TextFieldInput(
                    hintText: "Email eingeben",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    hintText: "Password eingeben",
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                      onTap: loginUser,
                      label: "Einloggen",
                      isLoading: _isLoading),
                  const SizedBox(height: 12),
                  Divider(),
                  const SizedBox(height: 12),
                  AuthButton(
                      onTap: navigateToSignup, label: "Account erstellen"),
                  const SizedBox(height: 12),
                  AuthButton(
                      onTap: navigateToForgotPassword,
                      label: "Passwort vergessen?"),
                ],
              )),
        ),
      ),
    );
  }
}
