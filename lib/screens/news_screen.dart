import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(children: [
          Container(
            margin: const EdgeInsets.only(left: 15, top: 75),
            child: Text(
              "Neuigkeiten",
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ],),);
  }
}