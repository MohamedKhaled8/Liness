import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isDarkMode = ChangeTranslateAndTheme.isDarkMode(context);
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              size: 22.sp,
              Icons.arrow_back,
              color: isDarkMode ? ColorsManger.white : ColorsManger.black,
            ),
          ),
          backgroundColor: ColorsManger.transparent,
          elevation: 0.0,
          title: Text(AppLocalizations.of(context)!
              .translate('Educational platform lines')),
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0.sp),
          children: [
            _buildContainer(
              title:
                  AppLocalizations.of(context)!.translate('About the platform'),
              content: AppLocalizations.of(context)!.translate(
                  'The Lines educational platform is an electronic platform that aims to provide distance education through a wide range of courses and lectures intended for students of different academic levels. The platform cooperates with an elite group of professional teachers to provide diverse educational content covering different subjects such as mathematics, science, and others. It gives students the opportunity to choose educational materials that suit their needs, which helps them improve their academic performance'),
            ),
            verticalSpace(5),
            _buildContainer(
                title: AppLocalizations.of(context)!.translate('Features'),
                content: AppLocalizations.of(context)!.translate(
                    'The platform is available through applications on mobile phones, where students can access their accounts, follow their progress, and easily register the subjects they want')),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer({required String title, required String content}) {
    return Container(
      padding: EdgeInsets.all(16.0.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          verticalSpace(5),
          Text(
            content,
            style: TextStyle(fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
