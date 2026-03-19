import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/vibration_method.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import '../main_profile_feature/data/model/api/recorde_model.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import '../profile_sessions_feature/helper/constants/profile_constants.dart';

class ProfileRecordWidget extends StatelessWidget {
  final ProfileRecordModel recordModel;
  final int index;

  const ProfileRecordWidget({
    super.key,
    required this.index,
    required this.recordModel,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    bool isArabic = ChangeTranslateAndTheme.isArabic;
    Color accentColor = pcBorderColors[index % pcBorderColors.length];

    double heightCard = double.infinity;
    double imageWidth = 35.w;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      height: heightCard,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: accentColor.withOpacity(0.12),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _handleNavigation(context),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            // --- Image Section ---
            Stack(
              children: [
                ClipRRect(
                  borderRadius: isArabic
                      ? const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )
                      : const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                  child: AppImageHelper(
                    path: recordModel.img,
                    fit: BoxFit.cover,
                    width: imageWidth,
                    height: heightCard,
                  ),
                ),

                // Icon Overlay
                Positioned(
                  bottom: 8,
                  right: isArabic ? null : 8,
                  left: isArabic ? 8 : null,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Icon(
                      recordModel.grade.isNotEmpty
                          ? Icons.assignment_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            // --- Content Section ---
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Date With Calendar Icon
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 12,
                          color: accentColor.withOpacity(0.7),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recordModel.date,
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                isDarkMode ? Colors.white54 : Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      recordModel.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : const Color(0xFF111827),
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Status Badge
                    if (recordModel.grade.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: ColorsManger.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${AppLocalizations.of(context)!.translate('Grades')}: ${recordModel.grade}",
                          style: const TextStyle(
                            color: ColorsManger.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('video'),
                          style: TextStyle(
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // --- Navigation Arrow ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Icon(
                isArabic
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: accentColor.withOpacity(0.3),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context) {
    handleTapVibration(() {
      if (recordModel.grade.isNotEmpty) {
        context.pushNamed(
          Routes.examScreen,
          arguments: [null, recordModel.id],
        );
      } else {
        context.pushNamed(
          Routes.sessionScreen,
          arguments: recordModel.id,
        );
      }
    });
  }
}
