import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/widgets/social_icons_widget.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class TeacherInfoView extends StatelessWidget {
  final TeacherCardModel teacherModel;
  const TeacherInfoView({
    super.key,
    required this.teacherModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = ChangeTranslateAndTheme.isDarkMode(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          verticalSpace(1.5),
          Divider(color: Colors.grey.withOpacity(0.1)),
          verticalSpace(1.5),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Teacher Avatar
              ClipRRect(
                borderRadius: BorderRadius.circular(10.sp),
                child: AppImageHelper(
                  height: 55.sp,
                  width: 55.sp,
                  path: teacherModel.image,
                  fit: BoxFit.cover,
                ),
              ),
              horizintalSpace(3.5),
              // Teacher Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherModel.nameTeacher,
                      style: StylesManager.textStyle18Bold(context).copyWith(
                        color: isDark ? Colors.white : ColorsManger.black,
                        fontSize: 16.5.sp,
                      ),
                    ),
                    verticalSpace(0.5),
                    Text(
                      "${teacherModel.job} ${AppLocalizations.of(context)!.translate('Teacher')}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (teacherModel.description.isNotEmpty) ...[
            verticalSpace(2),
            Text(
              teacherModel.description,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 13.sp,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          verticalSpace(2),

          // Row-aligned social icons
          SocialIconsRow(
            facebookLink: teacherModel.facebookLink,
            youtubeLink: teacherModel.youtubeLink,
            tiktokLink: teacherModel.tiktokLink,
          ),
        ],
      ),
    );
  }
}
