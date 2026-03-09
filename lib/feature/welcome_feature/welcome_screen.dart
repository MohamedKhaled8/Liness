import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/widgets/custom_buttons/custom_button_local.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0.sp,
              left: 0.sp,
              child: Image.asset(
                "assets/images/png/main_top.png",
                width: size.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0.sp,
              left: 0.sp,
              child: Image.asset(
                "assets/images/png/main_bottom.png",
                width: size.width * 0.2,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("Welcome To Liness"),
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: "ProtestGuerrilla-Regular",
                  ),
                ),
                verticalSpace(2),
                AppImageHelper(
                  path: "assets/images/svg/chat.svg",
                  height: size.height * 0.45,
                ),
                verticalSpace(5),
                ButtonLocal(
                  onTap: () {
                    context.pushNamed(Routes.loginScreen);
                  },
                  height: 6.5.h,
                  width: 80.w,
                  colorText: ColorsManger.white,
                  size: 20.h,
                  borderRadius: BorderRadius.circular(20),
                  isBorder: false,
                  colorButtom: ColorsManger.pColor,
                  child: Text(
                    AppLocalizations.of(context)!.translate("Login"),
                    style:
                        TextStyle(color: ColorsManger.white, fontSize: 18.sp),
                  ),
                ),
                verticalSpace(2),
                ButtonLocal(
                  onTap: () {
                    context.pushNamed(Routes.registerScreen);
                  },
                  height: 6.5.h,
                  width: 80.w,
                  colorText: ColorsManger.white,
                  size: 20.h,
                  borderRadius: BorderRadius.circular(20),
                  isBorder: false,
                  colorButtom: ColorsManger.gray.withOpacity(0.6),
                  child: Text(
                    AppLocalizations.of(context)!.translate("Register"),
                    style:
                        TextStyle(color: ColorsManger.white, fontSize: 18.sp),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
