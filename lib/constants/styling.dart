import 'package:flutter/material.dart';

Color yellowColor = const Color(0xFFF8A245);
Color darkYellowColor = const Color(0xFFE69A15);
Color redColor = const Color(0xFFFF2E00);
Color iconColor = const Color(0xFF9DB2CE);
Color textHeadingColor = const Color(0xFFCBC8C8);
Color textSubHeadingColor = const Color(0xFF847D7D);
Color matteBlackColor = const Color(0xFF2D2D2D);
Color blackColor = const Color(0xFF131313);

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

InputDecoration formInputDecoration(String labelText, String hintText) =>
    InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(color: textSubHeadingColor),
        borderRadius: BorderRadius.circular(20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: yellowColor),
        borderRadius: BorderRadius.circular(20),
      ),
      hintText: hintText,
      hintStyle: TextStyle(color: textSubHeadingColor),
      hintTextDirection: TextDirection.rtl,
      alignLabelWithHint: true,
      labelText: labelText,
      labelStyle: TextStyle(
        color: textHeadingColor,
      ),
    );

ButtonStyle registerButtonStyle(
  BuildContext context,
  Color backgroundColor,
  Color borderColor,
) =>
    ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: borderColor,
          width: 2.5,
        ),
      ),
      fixedSize:
          Size(screenWidth(context) * 0.6, screenHeight(context) * 0.055),
    );

TextStyle appBarTitleStyle(BuildContext context) => TextStyle(
      color: yellowColor,
      fontWeight: FontWeight.w500,
      fontSize: screenWidth(context) * 0.04,
    );
