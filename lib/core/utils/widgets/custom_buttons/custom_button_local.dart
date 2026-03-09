import 'package:flutter/material.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ButtonLocal extends StatelessWidget {
  final Widget child; // Changed from String to Widget
  final void Function()? onTap;
  final double height;
  final double width;
  final Color colorText;
  final double size;
  final Color? colorButtom;
  final BorderRadiusGeometry borderRadius;
  final bool isBorder;
  final BoxBorder? border;

  const ButtonLocal({
    Key? key,
    required this.child, // Changed from String to Widget
    this.onTap,
    required this.height,
    required this.width,
    required this.colorText,
    required this.size,
    this.colorButtom,
    required this.borderRadius,
    required this.isBorder,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: border,
          color: isBorder ? Colors.transparent : colorButtom,
        ),
        child: Center(
          child: child, // Use the Widget
        ),
      ),
    );
  }
}
