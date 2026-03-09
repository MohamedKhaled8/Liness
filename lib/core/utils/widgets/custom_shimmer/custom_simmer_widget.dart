import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BorderRadius? customBorderRadius;

  const CustomShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.customBorderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
