import 'package:co2fzs/resources/auth_methods.dart';
import 'package:co2fzs/resources/firestore_methods.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:co2fzs/utils/utils.dart';
import 'package:co2fzs/widgets/auth_button.dart';
import 'package:co2fzs/widgets/text_field_input.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
  }

  void resetPassword() async {
    String res = "Undefined Error";
    setState(() {
      _isLoading = true;
    });
    String _email = _emailController.text;
    int _emailLength = _email.length;
    if (_email[_emailLength - 1] == " ") {
      _email = _email.substring(0, _emailLength - 2);
    }
    try {
      res = await AuthMethods().sendResetPasswordMail(_emailController.text);
    } catch (e) {
      res = e.toString();
    }
    setState(() {
      _isLoading = false;
    });
    showSnackBar(context, res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextFieldInput(
              hintText: "Email",
              textEditingController: _emailController,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 12),
            AuthButton(
              onTap: resetPassword,
              label: "Zurücksetzungsmail schicken",
              isLoading: _isLoading,
            ),
            SizedBox(height: 12),
            AuthButton(
              onTap: () => Navigator.of(context).pop(),
              label: "Zurück",
              isLoading: _isLoading,
              color: lightRed,
            )
          ]),
        ),
      ),
    );
  }
}
