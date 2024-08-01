import 'package:flutter/material.dart';
import 'package:userapp/common/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? assetPath;
  final IconData? icon;
  const CustomButton(
      {Key? key,
      required this.text,
      this.backgroundColor,
      this.textColor,
      this.assetPath,
      this.icon,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(48),
        color: backgroundColor,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null ?
                Icon(icon, color: Colors.white70,) : SizedBox(),
            SizedBox(
              width: 5,
            ),
            Text(
              text,
              style: AppFonts.generalTextTheme(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
