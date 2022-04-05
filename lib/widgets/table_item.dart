import 'package:flutter/material.dart';

class TableItem extends StatelessWidget {
  final String label;
  final String info;
  const TableItem({
    Key? key,
    required this.info,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Text(info,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyText2),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
