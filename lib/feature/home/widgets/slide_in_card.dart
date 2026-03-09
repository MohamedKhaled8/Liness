import 'package:flutter/material.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
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
  // ignore: library_private_types_in_public_api
  _SlideInCardState createState() => _SlideInCardState();
}

class _SlideInCardState extends State<SlideInCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Delay the start of the animation based on the index
    Future.delayed(Duration(milliseconds: 600 * widget.index), () {
      _controller.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0), // Start from the left
      end: Offset.zero, // End at the original position
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
            context.pushNamed(
              Routes.sessionScreen,
              arguments: widget.session.id,
            );
          },
          child: TeacherResentSessionWidgets(
            widthImage: 60.w,
            heightImage: stv(
                context: context,
                mobile: otv(context: context, portrait: 13.h, landscape: 45.h),
                tablet: otv(context: context, portrait: 13.h, landscape: 37.h),
                desktop: 30.h),
            image: widget.session.img,
            imageTeacher: widget.session.name,
            nameCource: widget.session.course,
            index: widget.index,
            colorsList: widget.colorsList,
          ),
        ),
      ),
    );
  }
}
