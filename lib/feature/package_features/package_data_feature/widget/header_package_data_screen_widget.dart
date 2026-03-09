import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class HeaderPackageDataScreenWidgte extends StatelessWidget {
  const HeaderPackageDataScreenWidgte({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final packageDataCubit = context.read<PackageDataCubit>();
    final isArabic = ChangeTranslateAndTheme.isArabic;
    final isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Background image
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.sp),
            bottomRight: Radius.circular(20.sp),
          ),
          child: AppImageHelper(
            height: stv(
                context: context,
                mobile: otv(context: context, portrait: 33.h, landscape: 55.h),
                tablet: 55.h,
                desktop: 50.h),
            width: double.infinity,
            path: packageDataCubit.packageDataModel!.img,
            fit: BoxFit.fill,
          ),
        ),
        // Back arrow button
        Positioned(
          top: stv(
              context: context, mobile: 15.sp, tablet: 15.sp, desktop: 19.sp),
          left: 15.sp,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManger.gray.withOpacity(0.5)),
            child: IconButton(
              icon: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(isArabic ? 3.14 : 0),
                child: Icon(
                  Icons.arrow_back,
                  size: 24.sp,
                  color: isDarkMode ? ColorsManger.white : ColorsManger.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
