import 'package:co2fzs/models/transport_option.dart';
import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final TransportOption transport_option;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const ImageButton({
    Key? key,
    required this.transport_option,
    this.selected = false,
    required this.onTap,
    required this.onDoubleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.43,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          border: Border.all(width: selected ? 2 : 0.1, color: primaryColor),
          borderRadius: BorderRadius.circular(11),
        ),
        margin: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            transport_option.photoUrl,
            fit: BoxFit.cover,
            color: Colors.black45,
            colorBlendMode: !selected ? BlendMode.dstOut : BlendMode.lighten,
          ),
        ),
      ),
    );
  }
}
