import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/home/data/model/session_resent_model.dart';
import 'package:liness/core/utils/widgets/custom_teacher_resent_session.dart';

class SlideInCard extends StatefulWidget {
  final double screenWidth;
  final List<Color> colorsList;
  final SessionResentModel session;
  final int index;

  const SlideInCard({
    Key? key,
    required this.screenWidth,
    required this.colorsList,
    required this.session,
    required this.index,
  }) : super(key: key);

  @override
  State<SlideInCard> createState() => _SlideInCardState();
}

class _SlideInCardState extends State<SlideInCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    bool isArabic = ChangeTranslateAndTheme.isArabic;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Slide from left → right (English) or right → left (Arabic)
    double startX = isArabic ? 0.4 : -0.4;
    _slideAnimation = Tween<Offset>(
      begin: Offset(startX, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // Stagger: each card waits a bit after the previous one
    int delay = (widget.index.clamp(0, 6)) * 150;
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14.sp),
            splashColor: Colors.white10,
            highlightColor: Colors.transparent,
            onTap: () {
              context.pushNamed(
                Routes.sessionScreen,
                arguments: widget.session.id,
              );
            },
            child: TeacherResentSessionWidgets(
              widthImage: double.infinity,
              heightImage: stv(
                context: context,
                mobile: otv(context: context, portrait: 10.h, landscape: 16.h),
                tablet: otv(context: context, portrait: 9.h, landscape: 13.h),
                desktop: 10.h,
              ),
              image: widget.session.img,
              imageTeacher: widget.session.name,
              nameCource: widget.session.course,
              index: widget.index,
              colorsList: widget.colorsList,
            ),
          ),
        ),
      ),
    );
  }
}
