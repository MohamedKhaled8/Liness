import 'package:flutter/material.dart';
import '../../_logic/cubits/exam_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import '../../helper/get_answer_latter_from_number_funx.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';

class ExamAnswerCardWidget extends StatelessWidget {
  final int questionId;
  final int answerNumber;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool submitedQuestion;
  const ExamAnswerCardWidget({
    super.key,
    required this.answerNumber,
    required this.isSelected,
    required this.questionId,
    this.isCorrectAnswer = false,
    required this.submitedQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ////
        context.read<ExamCubit>().setUserAnswer(
              questionId: questionId,
              answerNumber: answerNumber,
            );
        ////
      },
      child: Container(
        height: otv(
          context: context,
          portrait: 4.h,
          landscape: 8.h,
        ),
        width: 95.w,
        margin: EdgeInsets.only(bottom: 10.sp),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCorrectAnswer
              ? ColorsManger.green
              : submitedQuestion
                  ? isSelected
                      ? ColorsManger.red
                      : ColorsManger.white
                  : isSelected
                      ? ColorsManger.primaryColor
                      : ColorsManger.white,
          border: Border.all(
            color: ColorsManger.primaryColor,
            width: 5.sp,
          ),
          borderRadius: BorderRadius.circular(14.sp),
        ),
        child: Text(
          getAnswerCharFromNumber(answerNumber: answerNumber),
          style: StylesManager.textStyle18Bold(context).copyWith(
            fontSize: 17.sp,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
