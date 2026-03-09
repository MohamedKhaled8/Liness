import 'package:flutter/material.dart';
import 'package:draggable_fab/draggable_fab.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/content_support.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class ContactSupport extends StatelessWidget {
  const ContactSupport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isArabic = ChangeTranslateAndTheme.isArabic;

    return DraggableFab(
      initPosition: Offset(MediaQuery.of(context).size.height / 2, 200),
      child: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: ColorsManger.mainColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.all(15.sp),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // إضافة الصورة في أعلى الـ BottomSheet
                      const AppImageHelper(
                        path: ImageAssetsManger.support,
                      ),
                      verticalSpace(2),
                      Text(
                        isArabic
                            ? "اختر طريقة التواصل"
                            : "Choose Contact Method",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManger.white,
                        ),
                      ),
                      verticalSpace(3),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(Icons.phone,
                              color: ColorsManger.primaryColor),
                          title: Text(
                            isArabic
                                ? "التواصل مع الدعم الفني (رقم 1)"
                                : "Contact Support (Number 1)",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          onTap: () {
                            contactSupport("+201116114409");
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      verticalSpace(1),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: const Icon(Icons.phone_android,
                              color: ColorsManger.primaryColor),
                          title: Text(
                            isArabic
                                ? "التواصل مع الدعم الفني (رقم 2)"
                                : "Contact Support (Number 2)",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          onTap: () {
                            contactSupport("+201505426733");
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: ColorsManger.transparent,
        child: const AppImageHelper(path: "assets/images/png/help.png"),
      ),
    );
  }
}
