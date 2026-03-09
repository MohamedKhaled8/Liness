import 'package:flutter/widgets.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/widgets/custom_shimmer/custom_simmer_widget.dart';

class ShimmerLoadingHome extends StatelessWidget {
  const ShimmerLoadingHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 37.h,
      width: double.infinity,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return CustomShimmerWidget(
            width: 65.w,
            height: 33.h,
            borderRadius: 10,
          );
        },
        separatorBuilder: (context, index) => SizedBox(width: 5.w),
        itemCount: 5,
      ),
    );
  }
}
