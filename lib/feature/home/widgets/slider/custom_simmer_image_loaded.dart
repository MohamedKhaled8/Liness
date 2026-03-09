import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/widgets/custom_shimmer/custom_simmer_widget.dart';

class CustomShimmerImageWidget extends StatelessWidget {
  const CustomShimmerImageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.0.sp),
            child: const CustomShimmerWidget(
              width: 300.0,
              height: 200.0,
            ),
          );
        },
      ),
    );
  }
}