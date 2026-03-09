import 'package:flutter/material.dart';

abstract class ColorsManger {
  ColorsManger._();

  static const primaryColor = Colors.blue;
  static const transparent = Colors.transparent;
  static const pColor = Color(0xFF6F35A5);
  static const kPColor = Color(0x0ff1e6ff);
  static const purple = Colors.purple;
  static const cyan = Colors.cyan;
  static const brown = Colors.brown;
  static const teal = Colors.teal;
  static const scaffolColor = Color.fromARGB(255, 1, 18, 28);
 static const Color lightBlue = Color(0xFF80D8FF); // Add lightBlue
  static const black = Colors.black;
  static const mainColor = Color(0xFF011520);
  static const black26 = Colors.black26;
  static const white = Colors.white;
  static const white24 = Colors.white24;
  static const white70 = Colors.white70;
  static const gray = Colors.grey;
  static const red = Colors.red;
  static const green = Colors.green;
  static const yellow = Colors.yellow;
  static const yellowDark = Color(0xFFe48400);
  static const orange = Colors.orange;
  static const pink = Color(0xFF443070);
  static const mainBlue = Color.fromARGB(255, 4, 101, 153);
  static const kSecondaryColor = Color(0xFF8B94BC);
  static const kGreenColor = Color(0xFF6AC259);
  static const kRedColor = Color(0xFFE92E30);
  static const kGrayColor = Color(0xFFC1C1C1);
  static const kBlackColor = Color(0xFF101010);
  static const kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
