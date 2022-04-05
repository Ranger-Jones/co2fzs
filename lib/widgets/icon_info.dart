import 'package:flutter/material.dart';

class IconInfo extends StatelessWidget {
  final IconData iconData;
  final String info;
  IconInfo({
    Key? key,
    required this.iconData,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          Icon(iconData, size: 35),
          Text(info, style: Theme.of(context).textTheme.bodyText1)
        ],
      ),
    );
  }
}
