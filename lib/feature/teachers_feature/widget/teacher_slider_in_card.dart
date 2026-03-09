import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/custom_teacher_card_widget.dart';

class TeacherSlideInCard extends StatefulWidget {
  final int index; // فهرس البطاقة
  final TeacherCardModel teacherCardModel; // نموذج المدرس

  const TeacherSlideInCard({
    Key? key,
    required this.index,
    required this.teacherCardModel,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TeacherSlideInCardState createState() => _TeacherSlideInCardState();
}

class _TeacherSlideInCardState extends State<TeacherSlideInCard>
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

    // تأخير الحركة بناءً على فهرس البطاقة
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
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
    return SlideTransition(
      position: _slideAnimation,
      child: InkWell(
        onTap: () {
          // هنا يمكن إضافة منطق الانتقال عند الضغط على بطاقة المدرس
        },
        child: CustomTeachersCardWidget(
          widthImage: 55.w,
          imageFit: BoxFit.fill,
          teacherCardModel: widget.teacherCardModel,
        ),
      ),
    );
  }
}
