import 'package:co2fzs/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => FirebaseAuth.instance.signOut(),
      icon: const Icon(
        Icons.power_settings_new,
        size: 40,
        color: primaryColor,
      ),
    );
  }
}
