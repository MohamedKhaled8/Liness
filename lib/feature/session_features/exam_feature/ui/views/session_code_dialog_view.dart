import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class SessionCodeDialog extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onSubmit;
  const SessionCodeDialog({
    super.key,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = StylesManager.isDarkMode(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.sp),
      ),
      backgroundColor: isDark ? const Color(0xFF1E272E) : ColorsManger.white,
      contentPadding: EdgeInsets.fromLTRB(20.sp, 20.sp, 20.sp, 10.sp),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("Enter Purchase Code"),
            style: StylesManager.textStyle18Bold(context).copyWith(
              color: isDark ? ColorsManger.white : ColorsManger.mainBlue,
              fontSize: 18.sp,
            ),
          ),
          SizedBox(height: 5.h),
          TextField(
            onChanged: (value) {
              onChanged(value);
            },
            style: TextStyle(
              color: isDark ? ColorsManger.white : ColorsManger.black,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!
                  .translate("Enter Purchase Code"),
              hintStyle: TextStyle(
                color: ColorsManger.gray.withOpacity(0.6),
                fontSize: 14.sp,
              ),
              prefixIcon: Icon(
                Icons.code_rounded,
                color: ColorsManger.mainBlue,
                size: 20.sp,
              ),
              filled: true,
              fillColor: isDark
                  ? ColorsManger.white.withOpacity(0.05)
                  : ColorsManger.gray.withOpacity(0.1),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide:
                    const BorderSide(color: ColorsManger.mainBlue, width: 1),
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.translate("Cancel"),
                  style: TextStyle(
                    color: ColorsManger.red.withOpacity(0.8),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  onSubmit();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManger.mainBlue,
                  foregroundColor: ColorsManger.white,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.sp),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.translate("Submit"),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
