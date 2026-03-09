import 'package:flutter/material.dart';
import '../views/student_info_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../views/student_states_count_view.dart';
import 'package:liness/core/utils/config/space.dart';
import '../widgets/custom_select_profile_widget.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/helper/app_image_helper.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/feature/profile_features/main_profile_feature/logic/cubit/profile_cubit.dart';
import 'package:liness/feature/profile_features/main_profile_feature/widgets/custom_app_bar_profile_screen_widget.dart';
import 'package:liness/core/utils/widgets/custom_ciecular_indicator_loading_widget/custom_circule_indicator_loading_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();
    profileCubit = context.read<ProfileCubit>();

    /// تحميل الصورة المخزنة
    profileCubit.loadCachedImage();

    /// تحميل بيانات البروفايل
    profileCubit.getProfileData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityMonitor(
      customDisconnectedWidget: const CustomDisconnectedWidget(),
      customDialog: const CustomDialogConnected(),
      child: Scaffold(
        appBar: const AppBarProfileScreenWidget(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8.0.sp),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const Center(child: LoadingIndicator());
                  }

                  if (profileCubit.profileModel != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SelectProfilePhotoWidget(),
                        verticalSpace(2),
                        const StudentInfoView(),
                        verticalSpace(2),
                        StudentsStatesCountView(
                          totalSessions: profileCubit.profileModel?.total ?? 0,
                          totalOpenedSessions:
                              profileCubit.profileModel?.opened ?? 0,
                          totalExams: profileCubit.profileModel?.exams ?? 0,
                        ),
                        verticalSpace(2),
                      ],
                    );
                  } else {
                    return Center(
                      child: AppImageHelper(
                        height: 65.h,
                        width: 90.w,
                        path: ImageAssetsManger.empty,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
