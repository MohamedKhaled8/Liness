import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:screen_go/extensions/screen_type_value.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:screen_go/extensions/orienation_type_value.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/teachers_feature/logic/cubit/teacher_cubit.dart';
import 'package:liness/feature/teachers_feature/widget/teacher_slider_in_card.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        body: BlocBuilder<TeacherCubit, TeacherState>(
          builder: (context, state) {
            if (state is TeacherLoadingState) {
              return const Center(
                child: LoadingIndicator(),
              );
            }

            return CustomScrollView(
              slivers: [
                ////
                SliverToBoxAdapter(
                  child: verticalSpace(8),
                ),
                ////
                SliverToBoxAdapter(
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        AppLocalizations.of(context)!
                            .translate('choose course'),
                        textAlign: TextAlign.center,
                        textStyle:
                            StylesManager.textStyle16v3FontFamile.copyWith(
                          fontFamily: "ProtestGuerrilla-Regular",
                        ),
                        speed: const Duration(milliseconds: 55),
                      ),
                    ],
                    totalRepeatCount: 1,
                  ),
                ),
                ////
                SliverToBoxAdapter(
                  child: verticalSpace(2),
                ),
                ////
                if (context
                    .read<TeacherCubit>()
                    .allTeachresDataModelList
                    .isNotEmpty) ...[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 18.sp,
                        crossAxisCount: stv(
                          context: context,
                          mobile: 1,
                          tablet: 2,
                          desktop: 3,
                        ),
                        childAspectRatio: stv(
                            context: context,
                            mobile: 4.22.sp,
                            tablet: 2.85.sp,
                            desktop: otv(
                              context: context,
                              portrait: 2.8.sp,
                              landscape: 2.3.sp,
                            )),
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return TeacherSlideInCard(
                            index: index,
                            teacherCardModel: context
                                .read<TeacherCubit>()
                                .allTeachresDataModelList[index],
                          );
                        },
                        childCount: context
                            .read<TeacherCubit>()
                            .allTeachresDataModelList
                            .length,
                      ),
                    ),
                  ),
                ] else ...[
                  const SliverToBoxAdapter(
                    child: Center(
                      child: AppImageHelper(
                        path: ImageAssetsManger.errornet,
                      ),
                    ),
                  ),
                ],
                ////
                SliverToBoxAdapter(
                  child: verticalSpace(10),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
