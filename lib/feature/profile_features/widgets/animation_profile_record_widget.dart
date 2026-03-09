import 'package:flutter/material.dart';
import 'package:liness/feature/profile_features/widgets/profile_record_widget.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/model/api/recorde_model.dart';

class AnimatedProfileRecordWidget extends StatefulWidget {
  final ProfileRecordModel recordModel;
  final int index;

  const AnimatedProfileRecordWidget({
    Key? key,
    required this.index,
    required this.recordModel,
  }) : super(key: key);

  @override
  State<AnimatedProfileRecordWidget> createState() =>
      _AnimatedProfileRecordWidgetState();
}

class _AnimatedProfileRecordWidgetState
    extends State<AnimatedProfileRecordWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // تأخير الحركة بناءً على الفهرس
    Future.delayed(Duration(milliseconds: widget.index * 30), () {
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
      child: ProfileRecordWidget(
        index: widget.index,
        recordModel: widget.recordModel,
      ),
    );
  }
}
