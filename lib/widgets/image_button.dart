import 'package:co2fzs/models/transport_option.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final TransportOption transport_option;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final bool web;

  const ImageButton({
    Key? key,
    required this.transport_option,
    this.selected = false,
    required this.onTap,
    required this.onDoubleTap,
    this.web = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Stack(
        children: [
          Container(
            width: web
                ? MediaQuery.of(context).size.width * 0.22
                : MediaQuery.of(context).size.width * 0.43,
            height: web
                ? MediaQuery.of(context).size.width * 0.22
                : MediaQuery.of(context).size.width * 0.43,
            decoration: BoxDecoration(
              border:
                  Border.all(width: selected ? 2 : 0.1, color: primaryColor),
              borderRadius: BorderRadius.circular(11),
            ),
            margin: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                transport_option.photoUrl,
                fit: BoxFit.cover,
                color: Colors.black45,
                colorBlendMode:
                    !selected ? BlendMode.dstOut : BlendMode.lighten,
              ),
            ),
          ),
          Positioned(
              child: selected
                  ? Text(transport_option.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontWeight: FontWeight.bold))
                  : Text(""),
              bottom: 20,
              left: 20),
        ],
      ),
    );
  }
}
