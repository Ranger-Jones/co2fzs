import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final String label;
  final String helperText;
  final TextEditingController controller;

  final Function onChanged;

  const SearchField({
    Key? key,
    required this.controller,
    required this.helperText,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: primaryColor,
      onChanged: (text) => onChanged(),
      onSaved: (text) => onChanged(),
      onTap: () => onChanged(),
      controller: controller,
      style:
          Theme.of(context).textTheme.headline3!.copyWith(letterSpacing: 1.25),
      decoration: InputDecoration(
        icon: const Icon(Icons.search_sharp),
        labelText: label,
        labelStyle: const TextStyle(
          color: primaryColor,
        ),
        disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: textColor)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: primaryColor)),
      ),
    );
  }
}
