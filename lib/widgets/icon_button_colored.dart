import 'package:auto_size_text/auto_size_text.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IconButtonColored extends StatelessWidget {
  final IconData data;
  final Function onPressed;
  final Color color;
  final String label;
  final bool active;
  const IconButtonColored({
    Key? key,
    required this.data,
    required this.onPressed,
    this.color = primaryColor,
    this.active = false,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kIsWeb ? 12 : 0),
      width: kIsWeb
          ? MediaQuery.of(context).size.width * 0.15
          : MediaQuery.of(context).size.width * 0.31,
      height: kIsWeb
          ? MediaQuery.of(context).size.width * 0.035
          : MediaQuery.of(context).size.width * 0.15,
      decoration: ShapeDecoration(
        shape: active
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            : OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        color: active ? color : Colors.white,
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              data,
              color: active ? Colors.white : textColor,
            ),
            AutoSizeText(
              label,
              style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: active ? Colors.white : textColor,
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
              minFontSize: 12,
            )
          ],
        ),
      ),
    );
  }
}
