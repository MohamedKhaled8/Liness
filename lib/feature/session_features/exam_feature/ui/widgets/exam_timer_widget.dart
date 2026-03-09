import 'package:flutter/widgets.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class ExamTimerWidget extends StatefulWidget {
  final double examTimeBySeconed;
  final Function(int) timeCallBack;
  const ExamTimerWidget({
    super.key,
    required this.examTimeBySeconed,
    required this.timeCallBack,
  });

  @override
  State<ExamTimerWidget> createState() => _ExamTimerWidgetState();
}

class _ExamTimerWidgetState extends State<ExamTimerWidget> {
  ////
  late CountdownTimerController controller;
  ////
  int currentTime = 0;
  ////
  void lis() {
    widget.timeCallBack(((currentTime / 1000) - 1).toInt());
  }
  ////

  @override
  void initState() {
    ////
    currentTime = (DateTime.now().millisecondsSinceEpoch +
            Duration(seconds: widget.examTimeBySeconed.toInt()).inMilliseconds)
        .toInt();
    ////
    controller = CountdownTimerController(
      endTime: currentTime,
    );
    ////
    controller.addListener(() {
      lis();
    });
    ////
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(lis);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ////
        Text(
          AppLocalizations.of(context)!.translate('Time Left'),
          style: StylesManager.textStyle18Bold(context),
        ),
        ////
        Directionality(
          textDirection: TextDirection.ltr,
          child: CountdownTimer(
            controller: controller,
            // endTime: DateTime.now().millisecondsSinceEpoch +
            //     (examTimeByMenuties * 60) * 1000,
            onEnd: () {},
            textStyle: StylesManager.textStyle18Bold(context),
          ),
        ),

        ////
      ],
    );
  }
}
