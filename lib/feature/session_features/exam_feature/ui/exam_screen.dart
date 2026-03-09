import 'package:flutter/material.dart';
import 'widgets/exam_timer_widget.dart';
import '../_logic/states/exam_state.dart';
import 'widgets/exam_question_widget.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/core/utils/widgets/custom_buttons/main_button_widget.dart';
import 'package:liness/feature/session_features/exam_feature/_logic/cubits/exam_cubit.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ////
    final examCubit = context.read<ExamCubit>();
    ////

    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        body: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoadingState) {
              return const LoadingIndicator();
            }

            return SafeArea(
              child: examCubit.examModel != null
                  ? Column(
                      children: [
                        // AnimatedTextKit(
                        //   animatedTexts: [
                        //     ////
                        //     TypewriterAnimatedText(
                        //       examCubit.examModel!.examName,
                        //       textAlign: TextAlign.center,
                        //       textStyle:
                        //           StylesManager.textStyle18Bold(context).copyWith(
                        //         fontFamily: StylesManager.fontFamile,
                        //         fontSize: 17.sp,
                        //         color: Colors.white,
                        //       ),
                        //       speed: const Duration(milliseconds: 55),
                        //     ),
                        //     ////
                        //   ],
                        //   totalRepeatCount: 1,
                        // ),
                        //// EXAM TIMER WIDGET
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                            vertical: 3.sp,
                          ),
                          child: examCubit.examModel?.total.isNotEmpty ?? false
                              ? Center(
                                  child: Text(
                                    examCubit.examModel?.total ?? '',
                                    style: StylesManager.textStyle16FontFamile
                                        .copyWith(
                                      fontSize: 20.sp,
                                      color: ColorsManger.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              : ExamTimerWidget(
                                  examTimeBySeconed:
                                      examCubit.examModel!.examTime.toDouble(),
                                  timeCallBack: (currentTime) {
                                    examCubit.examModel!.examTime = currentTime;
                                  },
                                ),
                        ),
                        ////
                        Expanded(
                          child: ListView.builder(
                            cacheExtent: 1000,
                            itemCount:
                                examCubit.examModel!.examQuestions.length,
                            itemBuilder: (context, index) => ExamQuestionWidget(
                              questionIndex: index,
                              questionModel:
                                  examCubit.examModel!.examQuestions[index],
                            ),
                          ),
                        ),
                        ////
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ////
                            if (examCubit.examModel?.result.isEmpty ??
                                false) ...[
                              SizedBox(
                                width: 75.w,
                                child: MainButtonWidget(
                                  height: 5.h,
                                  title: examCubit.examModel?.isPass ?? false
                                      ? AppLocalizations.of(context)!
                                          .translate('Go to Session')
                                      : AppLocalizations.of(context)!
                                          .translate('Submit'),
                                  onTap: () async {
                                    if (examCubit.examModel?.isPass ?? false) {
                                      context.pushReplacementNamed(
                                        Routes.videoScreen,
                                        arguments: examCubit.sessionId,
                                      );
                                    } else {
                                      await examCubit.submitExam(
                                          context: context);
                                    }
                                  },
                                ),
                              ),
                            ],
                            ////
                            if (examCubit.examModel?.total.isEmpty ??
                                false) ...[
                              Text(
                                "${examCubit.userAnswers.length}/${examCubit.examModel?.examQuestions.length ?? 0}",
                                style: StylesManager.textStyle16FontFamile,
                              ),
                            ],
                            ////
                          ],
                        ),
                        ////
                      ],
                    )
                  : const Center(
                      child: AppImageHelper(
                        path: ImageAssetsManger.errornet,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
