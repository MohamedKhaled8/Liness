import 'package:flutter/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/widgets/package_widget.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';

class PackagesSliderView extends StatelessWidget {
  final List<PackageModel> packageModelList;

  const PackagesSliderView({
    super.key,
    required this.packageModelList,
  });

  @override
  Widget build(BuildContext context) {
    if (packageModelList.isEmpty) {
      return const AppImageHelper(
        path: ImageAssetsManger.errornet,
      );
    }

    return SizedBox(
      height: stv(
        context: context,
        mobile: otv(context: context, portrait: 37.h, landscape: 90.h),
        tablet: otv(context: context, portrait: 37.h, landscape: 75.h),
        desktop: otv(context: context, portrait: 65.h, landscape: 90.h),
      ),
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: packageModelList.length,
        itemBuilder: (context, index, realIndex) {
          return PackageWidget(
            imageFit: BoxFit.fill,
            widthImage: stv(
              mobile: otv(context: context, portrait: 65.w, landscape: 35.w),
              tablet: otv(context: context, portrait: 55.w, landscape: 35.w),
              desktop: otv(context: context, portrait: 40.w, landscape: 35.w),
              context: context,
            ),
            heightImage: 33.h,
            packageModel: packageModelList[index],
          );
        },
        options: CarouselOptions(
          height: stv(
            context: context,
            mobile: otv(context: context, portrait: 37.h, landscape: 90.h),
            tablet: otv(context: context, portrait: 37.h, landscape: 75.h),
            desktop: otv(context: context, portrait: 125.h, landscape: 80.h),
          ),
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 1500),
          enlargeCenterPage: true,
          viewportFraction: stv(
              context: context,
              mobile: otv(context: context, portrait: 0.8, landscape: 0.6),
              tablet: otv(context: context, portrait: 0.7, landscape: 0.5),
              desktop: 0.6),
          aspectRatio: 16 / 9,
          onPageChanged: (index, reason) {
            // TODO: NAVIGATE TO PACKAGES SCREEN
          },
        ),
      ),
    );
  }
}
