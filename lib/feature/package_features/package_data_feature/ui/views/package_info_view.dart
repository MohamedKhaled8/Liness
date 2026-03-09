import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/function/luncher_url.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/dialoges/code_dialoges/show_code_dialog.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/package_features/package_data_feature/logic/cubit/package_data_cubit.dart';
import 'package:liness/feature/package_features/package_data_feature/widget/open_package_successWidget.dart';

class PackageInfoView extends StatelessWidget {
  const PackageInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final packageDataCubit = context.read<PackageDataCubit>();
    final isDark = ChangeTranslateAndTheme.isDarkMode(context);
    final locale = AppLocalizations.of(context)!;

    if (packageDataCubit.packageDataModel == null) return const SizedBox();
    final packageModel = packageDataCubit.packageDataModel!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Package Name
          Text(
            packageModel.name,
            style: StylesManager.textStyle18Bold(context).copyWith(
              fontSize: 20.sp,
              height: 1.25,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          verticalSpace(1.5),

          // 2. Package Desc
          if (packageModel.des.isNotEmpty) ...[
            Text(
              packageModel.des,
              style: StylesManager.textStyle16Gray(context).copyWith(
                fontSize: 14.sp,
                height: 1.25,
              ),
            ),
            verticalSpace(1.5),
          ],

          // 3. Price Tag
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${packageModel.price} ${locale.translate('EGP')}",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                  height: 1,
                ),
              ),
              horizintalSpace(3),
              Padding(
                padding: EdgeInsets.only(
                    bottom: 2.sp), // align with bottom of price text
                child: _buildModernTag(context, locale.translate('Package'),
                    Colors.grey[700]!, isDark),
              ),
            ],
          ),

          verticalSpace(3),

          // 4. Action Buttons
          BlocBuilder<PackageDataCubit, PackageDataState>(
            builder: (context, state) {
              if (packageModel.notBuy) {
                return Column(
                  children: [
                    _buildActionButton(
                      context: context,
                      title: locale.translate("Enter code"),
                      icon: Icons.vpn_key_outlined,
                      onPressed: () async {
                        handleTapVibration(() async {
                          showCodeDialog(
                            context: context,
                            onSubmit: (code) async {
                              await context
                                  .read<PackageDataCubit>()
                                  .openPackage(
                                    context: context,
                                    code: code,
                                  );
                            },
                          );
                        });
                      },
                      isPrimary: true,
                    ),
                    verticalSpace(1.5),
                    _buildActionButton(
                      context: context,
                      title: locale.translate("Fawry pay"),
                      icon: Icons.payments_outlined,
                      onPressed: () =>
                          _showFawryDialog(context, packageDataCubit),
                      isPrimary: false,
                    ),
                    verticalSpace(2),
                  ],
                );
              } else {
                return const Center(child: OpendPackageSuccessWidget());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModernTag(
      BuildContext context, String text, Color color, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.sp),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: isDark ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: 13.sp),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    final isDark = ChangeTranslateAndTheme.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: Material(
        color: isPrimary
            ? ColorsManger.mainBlue
            : (isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12.sp),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12.sp),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.sp),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 20.sp,
                    color: isPrimary
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87)),
                horizintalSpace(2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isPrimary
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFawryDialog(
      BuildContext context, PackageDataCubit packageDataCubit) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: ChangeTranslateAndTheme.isDarkMode(context)
              ? const Color(0xFF111111)
              : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.sp)),
          title: Text(
            ChangeTranslateAndTheme.isArabic ? "ملاحظة هامة" : "Important Note",
            textAlign: TextAlign.center,
            style: StylesManager.textStyle18Bold(context),
          ),
          content: Text(
            ChangeTranslateAndTheme.isArabic
                ? "لن يتم الدفع مباشرة. ستحصل على كود دفع تتوجه به لأقرب ماكينة فوري."
                : "Payment is not direct. You will get a code to pay at any Fawry machine.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(ChangeTranslateAndTheme.isArabic ? "إلغاء" : "Cancel",
                  style: const TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManger.mainBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.sp)),
              ),
              onPressed: () async {
                handleTapVibration(() async {
                  if (packageDataCubit.packageDataModel?.payLink != null) {
                    await launchURL(
                        packageDataCubit.packageDataModel!.payLink!);
                    if (context.mounted) {
                      Navigator.pop(dialogContext); // close dialog
                      context.pop(); // close outer screen or bottom sheet ?
                      await context.read<PackageDataCubit>().getPackageDataData(
                            packageId: packageDataCubit.packageId,
                            context: context,
                          );
                    }
                  }
                });
              },
              child: Text(
                  ChangeTranslateAndTheme.isArabic ? "متابعة" : "Proceed",
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
