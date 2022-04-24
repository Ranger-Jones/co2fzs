import 'package:auto_size_text/auto_size_text.dart';
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyText2!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
         
              AutoSizeText(
                info,
                style: Theme.of(
                  context,
                ).textTheme.bodyText2,
                maxLines: 2,
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
