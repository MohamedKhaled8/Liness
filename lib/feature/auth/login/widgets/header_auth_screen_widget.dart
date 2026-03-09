import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class HeaderAuthScreenWidget extends StatelessWidget {
  const HeaderAuthScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        verticalSpace(6),
        Icon(
          Icons.menu_book_sharp,
          size: 30.sp,
          color: ColorsManger.white,
        ),
        verticalSpace(3),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    "${AppLocalizations.of(context)!.translate("Welcome To")}\n",
                style: TextStyle(
                    fontSize: stv(
                        context: context,
                        mobile: 20.sp,
                        tablet: 20.sp,
                        desktop: 22.sp),
                    fontFamily: "ProtestGuerrilla-Regular",
                    color: ColorsManger.white),
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.translate("Liness"),
                style: TextStyle(
                    fontSize: stv(
                        context: context,
                        mobile: 35.sp,
                        tablet: 35.sp,
                        desktop: 30.sp),
                    fontFamily: "ProtestGuerrilla-Regular",
                    color: ColorsManger.white),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
