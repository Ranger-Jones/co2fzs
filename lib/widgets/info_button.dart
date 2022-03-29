import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoButton extends StatelessWidget {
  final String assetUrl;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;
  const InfoButton({
    Key? key,
    required this.assetUrl,
    required this.label,
    this.backgroundColor = primaryColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundColor,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SvgPicture.asset(
                  assetUrl,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Positioned(
                top: 15,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
