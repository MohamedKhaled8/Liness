import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

class MainButtonWidget extends StatefulWidget {
  final String title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double? padding;

  const MainButtonWidget({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    this.iconColor,
    this.height,
    this.width,
    this.padding,
  });

  @override
  State<MainButtonWidget> createState() => _MainButtonWidgetState();
}

class _MainButtonWidgetState extends State<MainButtonWidget>
    with SingleTickerProviderStateMixin {
  bool isHovering = false;
  late AnimationController _controller;
  final Color color1 = ColorsManger.primaryColor;
  final Color color2 = ColorsManger.mainColor;
  final Color color3 = Colors.lightBlueAccent; // لون متناسق مع primaryColor
  final Color color4 =
      const Color(0xFF3E8E41); // A green shade complementing the blue tones

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              height: widget.height ?? 3.5.h,
              width: widget.width,
              padding:
                  EdgeInsets.symmetric(horizontal: widget.padding ?? 14.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: LinearGradient(
                  colors: const [
                    ColorsManger.mainColor,
                    ColorsManger.primaryColor,
                  ],
                  transform: isHovering
                      ? GradientRotation(_controller.value * 3 * pi)
                      : null, // Animated gradient during hover Use a default fallback color here
                ),
                boxShadow: [
                  BoxShadow(
                    color: color2.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset:
                        Offset.fromDirection(_controller.value * 2 * pi, 3.5),
                  ),
                  BoxShadow(
                    color: color1.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset:
                        Offset.fromDirection(_controller.value * 2 * pi, -3.5),
                  ),
                  BoxShadow(
                    color: color3.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset:
                        Offset.fromDirection(_controller.value * 2 * pi, -3.5),
                  ),
                  BoxShadow(
                    color: color4.withOpacity(0.6),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset:
                        Offset.fromDirection(_controller.value * 2 * pi, 3.5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      color: widget.iconColor ?? ColorsManger.white,
                    ),
                    horizintalSpace(1.5),
                  ],
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color:
                          isHovering ? ColorsManger.black : ColorsManger.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
