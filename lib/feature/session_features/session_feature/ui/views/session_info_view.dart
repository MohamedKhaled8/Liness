import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../helper/enums/session_types.dart';
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
import '../../helper/functions/get_session_type_from_session_enum_funx.dart';
import 'package:liness/feature/session_features/session_feature/model/data/session_model.dart';
import 'package:liness/feature/session_features/session_feature/_logic/cubits/session_cubit.dart';
import 'package:liness/feature/session_features/session_feature/_logic/states/session_state.dart';

class SessionInfoView extends StatelessWidget {
  final SessionModel sessionModel;
  const SessionInfoView({
    super.key,
    required this.sessionModel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ChangeTranslateAndTheme.isDarkMode(context);
    final locale = AppLocalizations.of(context)!;
    const primaryColor = ColorsManger.mainBlue;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Session Name - Big and Clear
          Text(
            sessionModel.sessionName,
            style: StylesManager.textStyle18Bold(context).copyWith(
              fontSize: 20.sp,
              height: 1.25,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),

          verticalSpace(1.5),

          // 2. Price & Type Row
          Row(
            children: [
              _buildModernTag(
                  context,
                  "${sessionModel.sessionPrice} ${locale.translate('EGP')}",
                  primaryColor,
                  isDark),
              horizintalSpace(2),
              _buildModernTag(
                  context,
                  getSessionTypeFromSessionEnum(
                      sessionTypesEnum: sessionModel.sessionType,
                      context: context),
                  Colors.grey[700]!,
                  isDark),
            ],
          ),

          if (sessionModel.sessionType != SessionTypesEnum.exam) ...[
            verticalSpace(1.5),
            Row(
              children: [
                Icon(Icons.history_toggle_off,
                    size: 16.sp,
                    color: sessionModel.sessionTimes == 0
                        ? Colors.red
                        : Colors.green),
                horizintalSpace(1.5),
                Text(
                  "${sessionModel.sessionTimes} ${locale.translate('times left')}",
                  style: TextStyle(
                    color: sessionModel.sessionTimes == 0
                        ? Colors.red
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ],

          verticalSpace(3),

          // 3. Action Buttons - Tight and Fixed Sizing issue
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              return Column(
                children: [
                  if (!sessionModel.isClosed)
                    _buildActionButton(
                      context: context,
                      title:
                          (sessionModel.sessionType == SessionTypesEnum.video ||
                                  (sessionModel.sessionType ==
                                          SessionTypesEnum.examAndVideo &&
                                      sessionModel.isExamDone))
                              ? locale.translate('Open session')
                              : locale.translate('Open exam'),
                      icon: (sessionModel.sessionType == SessionTypesEnum.video)
                          ? Icons.play_arrow_rounded
                          : Icons.edit_note_rounded,
                      onPressed: () => context
                          .read<SessionCubit>()
                          .goToSession(context: context),
                      isPrimary: true,
                    )
                  else ...[
                    _buildActionButton(
                      context: context,
                      title: locale.translate("Enter code"),
                      icon: Icons.vpn_key_outlined,
                      onPressed: () async {
                        handleTapVibration(() async {
                          await context
                              .read<SessionCubit>()
                              .checkLoginAndShowMessage(context);
                          if (context.mounted) {
                            await showCodeDialog(
                              context: context,
                              onSubmit: (code) async {
                                await context.read<SessionCubit>().openSession(
                                      context: context,
                                      code: code.replaceAll(' ', ''),
                                    );
                              },
                            );
                          }
                        });
                      },
                      isPrimary: true,
                    ),
                    verticalSpace(1.5),
                    _buildActionButton(
                      context: context,
                      title: locale.translate("Fawry pay"),
                      icon: Icons.payments_outlined,
                      onPressed: () => _showFawryDialog(context),
                      isPrimary: false,
                    ),
                  ],

                  verticalSpace(2),

                  // Simple centered link
                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        locale.translate("More sessions"),
                        style: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey,
                          fontSize: 14.sp,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              );
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
            padding: EdgeInsets.symmetric(
                vertical: 14.sp), // Standardized height by padding
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

  void _showFawryDialog(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
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
                if (sessionModel.payLink.isNotEmpty) {
                  await launchURL(sessionModel.payLink);
                  if (context.mounted) {
                    Navigator.pop(dialogContext);
                    await sessionCubit.getSessionData(
                        sessionId: sessionModel.id, context: context);
                  }
                }
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
