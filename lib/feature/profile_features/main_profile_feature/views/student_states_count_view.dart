import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/config/space.dart';
import '../widgets/studnet_states_count_widget.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/profile_features/main_profile_feature/logic/cubit/profile_cubit.dart';

class StudentsStatesCountView extends StatelessWidget {
  final int totalSessions;
  final int totalOpenedSessions;
  final int totalExams;
  const StudentsStatesCountView({
    super.key,
    required this.totalSessions,
    required this.totalOpenedSessions,
    required this.totalExams,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        children: [
          ////
          StudentStatesCountWidget(
            onTap: () {
              context.pushNamed(
                Routes.profileSessionsScreen,
                arguments:
                    context.read<ProfileCubit>().profileModel?.records ?? [],
              );
            },
            color: ColorsManger.mainBlue.withOpacity(0.4),
            title: AppLocalizations.of(context)!.translate('Code is Empty'),
            count: totalSessions,
            image: ImageAssetsManger.sisson,
          ),
          ////
          verticalSpace(2),
          ////
          StudentStatesCountWidget(
            onTap: () {
              context.pushNamed(
                Routes.profileSessionsScreen,
                arguments:
                    context.read<ProfileCubit>().profileModel?.records ?? [],
              );
            },
            color: const Color(0xFF2e2940),
            title: AppLocalizations.of(context)!
                .translate('Total Opened Sessions'),
            count: totalOpenedSessions,
            image: ImageAssetsManger.total,
          ),
          ////
          verticalSpace(2),
          ////
          StudentStatesCountWidget(
            onTap: () {
              context.pushNamed(
                Routes.profileGradesScreen,
              );
            },
            color: const Color(0xFF203332),
            title: AppLocalizations.of(context)!.translate('Exams Taken'),
            count: totalExams,
            image: ImageAssetsManger.exam,
          ),
          ////
        ],
      ),
    );
  }
}
