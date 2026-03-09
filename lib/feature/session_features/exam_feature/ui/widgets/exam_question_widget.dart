import 'package:flutter/widgets.dart';
import 'exam_answer_card_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/session_features/exam_feature/_logic/cubits/exam_cubit.dart';
import 'package:liness/feature/session_features/exam_feature/_logic/states/exam_state.dart';
import 'package:liness/feature/session_features/exam_feature/model/exam_question_model.dart';

class ExamQuestionWidget extends StatelessWidget {
  final int questionIndex;
  final ExamQuestionModel questionModel;
  const ExamQuestionWidget({
    super.key,
    required this.questionModel,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30.h,
      width: 95.w,
      padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 11.sp),
      margin: EdgeInsets.symmetric(vertical: 11.sp),
      decoration: BoxDecoration(
        color: ColorsManger.white,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(
          color: ColorsManger.primaryColor,
          width: 2.sp,
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 2),
            color: ColorsManger.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          ////
          Stack(
            clipBehavior: Clip.none,
            children: [
              ////
              ClipRRect(
                borderRadius: BorderRadius.circular(14.sp),
                child: AppImageHelper(
                  height: otv(
                    context: context,
                    portrait: 25.h,
                    landscape: 30.h,
                  ),
                  width: 95.w,
                  path: questionModel.questionImage,
                  fit: BoxFit.contain,
                ),
              ),
              ////
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.sp,
                  vertical: 5.sp,
                ),
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor,
                  borderRadius: BorderRadius.circular(11.sp),
                ),
                child: Text(
                  "${questionModel.questionPoints} ${AppLocalizations.of(context)!.translate('pt')}",
                  style: StylesManager.textStyle17White.copyWith(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              ////
            ],
          ),
          ////
          SizedBox(height: 1.5.h),
          //// ALL QUESTION ANSWERS
          BlocBuilder<ExamCubit, ExamState>(
            builder: (context, state) {
              return IgnorePointer(
                ignoring: questionModel.correctAnswer != null,
                child: Column(
                  children: [
                    ExamAnswerCardWidget(
                      questionId: questionModel.questionId,
                      answerNumber: 1,
                      isCorrectAnswer: questionModel.correctAnswer == 1,
                      submitedQuestion: questionModel.correctAnswer != null,
                      isSelected: context.read<ExamCubit>().getSelectedAnswer(
                            questionIndex: questionIndex,
                            questionId: questionModel.questionId,
                            answerNumber: 1,
                          ),
                    ),
                    ExamAnswerCardWidget(
                      questionId: questionModel.questionId,
                      answerNumber: 2,
                      isCorrectAnswer: questionModel.correctAnswer == 2,
                      submitedQuestion: questionModel.correctAnswer != null,
                      isSelected: context.read<ExamCubit>().getSelectedAnswer(
                            questionIndex: questionIndex,
                            questionId: questionModel.questionId,
                            answerNumber: 2,
                          ),
                    ),
                    ExamAnswerCardWidget(
                      questionId: questionModel.questionId,
                      answerNumber: 3,
                      isCorrectAnswer: questionModel.correctAnswer == 3,
                      submitedQuestion: questionModel.correctAnswer != null,
                      isSelected: context.read<ExamCubit>().getSelectedAnswer(
                            questionIndex: questionIndex,
                            questionId: questionModel.questionId,
                            answerNumber: 3,
                          ),
                    ),
                    ExamAnswerCardWidget(
                      questionId: questionModel.questionId,
                      answerNumber: 4,
                      isCorrectAnswer: questionModel.correctAnswer == 4,
                      submitedQuestion: questionModel.correctAnswer != null,
                      isSelected: context.read<ExamCubit>().getSelectedAnswer(
                            questionIndex: questionIndex,
                            questionId: questionModel.questionId,
                            answerNumber: 4,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
          ////
        ],
      ),
    );
  }
}
