import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/course_and_session_widget.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';

class CourseSlideInCard extends StatefulWidget {
  final double screenWidth;
  final List<Color> colorsList;
  final CourseAndSessionCardModel courseModel;
  final int index; // إضافة الفهرس لتحديد التأخير لكل كارد

  const CourseSlideInCard({
    Key? key,
    required this.screenWidth,
    required this.colorsList,
    required this.courseModel,
    required this.index, // تمرير الفهرس
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CourseSlideInCardState createState() => _CourseSlideInCardState();
}

class _CourseSlideInCardState extends State<CourseSlideInCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // تأخير الحركة بناءً على الفهرس
    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      _controller.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // البداية من اليسار
      end: Offset.zero, // النهاية في الموضع الأصلي
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.screenWidth,
      child: SlideTransition(
        position: _slideAnimation,
        child: InkWell(
          onTap: () {
            if (widget.courseModel.isCourseType) {
              context.pushNamed(
                Routes.sessionsScreen,
                arguments: widget.courseModel.id,
              );
            } else {
              context.pushNamed(
                Routes.sessionScreen,
                arguments: widget.courseModel.id,
              );
            }
          },
          child: CourseAndSessionWidget(
            courseAndSessionModel: widget.courseModel,
          ),
        ),
      ),
    );
  }
}
