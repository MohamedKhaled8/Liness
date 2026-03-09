import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/widgets/custom_shimmer/custom_simmer_widget.dart';

class CustomShimmerSessionRecentWidget extends StatelessWidget {
  const CustomShimmerSessionRecentWidget({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: SizedBox(
              width: screenWidth,
              child: CustomShimmerWidget(
                width: 60.w,
                height: 13.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
