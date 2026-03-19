import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/Router/export_routes.dart';

class SessionStatsView extends StatefulWidget {
  final int sessionId;
  const SessionStatsView({Key? key, required this.sessionId}) : super(key: key);

  @override
  State<SessionStatsView> createState() => _SessionStatsViewState();
}

class _SessionStatsViewState extends State<SessionStatsView> {
  int watchPercent = 0;
  int entryCount = 0;
  String stoppedTime = "00:00";

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      watchPercent = getIt<CacheHelper>().getData(key: 'watch_percent_x_${widget.sessionId}') ?? 0;
      entryCount = getIt<CacheHelper>().getData(key: 'entry_count_x_${widget.sessionId}') ?? 0;
      stoppedTime = getIt<CacheHelper>().getData(key: 'stopped_time_x_${widget.sessionId}') ?? "00:00";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ChangeTranslateAndTheme.isDarkMode(context);
    final isArabic = ChangeTranslateAndTheme.isArabic;
    
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      padding: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
        ),
        boxShadow: isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: ColorsManger.mainBlue, size: 20.sp),
              horizintalSpace(2),
              Text(
                isArabic ? "إحصائيات المشاهدة" : "Watch Statistics",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          verticalSpace(2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context: context,
                icon: Icons.pie_chart_outline,
                title: isArabic ? "نسبة المشاهدة" : "Watched",
                value: "$watchPercent%",
                color: ColorsManger.mainBlue,
                isDark: isDark,
              ),
              _buildStatItem(
                context: context,
                icon: Icons.login_outlined,
                title: isArabic ? "تكرار الدخول" : "Entries",
                value: "$entryCount ${isArabic ? 'مرات' : 'times'}",
                color: Colors.green,
                isDark: isDark,
              ),
              _buildStatItem(
                context: context,
                icon: Icons.timer_outlined,
                title: isArabic ? "وقت التوقف" : "Stopped",
                value: stoppedTime,
                color: Colors.orange,
                isDark: isDark,
              ),
            ],
          ),
          verticalSpace(2),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.sp),
            child: LinearProgressIndicator(
              value: watchPercent / 100,
              backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(ColorsManger.mainBlue),
              minHeight: 6.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.sp),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        verticalSpace(1),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
        verticalSpace(0.5),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }
}
