import 'package:co2fzs/utils/colors.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;
  final String label;
  const AuthButton({
    Key? key,
    this.isLoading = false,
    required this.onTap,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Colors.white),
              ),
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(6),
            ),
          ),
          color: primaryColor,
        ),
      ),
    );
  }
}
