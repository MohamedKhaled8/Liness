import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/Router/app_router.dart';
import 'package:liness/feature/home/ui/home_screen.dart';
import 'package:liness/feature/home/logic/cubit/home_cubit.dart';
import 'package:liness/feature/subject_feature/ui/subject_screen.dart';
part 'bottom_navigation_bar_state.dart';

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit() : super(const BottomNavigationBarInitial(0));

  void setSelectIndex(int index) {
    if (isClosed) return;
    if (index >= 0 && index < screen.length) {
      emit(BottomNavigationBarUpdated(index));
    }
  }

  final screen = [
    BlocProvider(
      create: (context) => HomeCubit()
        ..loadImages()
        ..getPackagesData()
        ..loadTeachers()
        ..loadSessionResent(),
      child: const HomeScreen(),
    ),
    const SubjectScreen(),
    AppRouter.getScreenByName(
      screenName: Routes.coursesScreen,
    ),
    AppRouter.getScreenByName(
      screenName: Routes.teachersScreen,
    ),
    ////
    AppRouter.getScreenByName(
      screenName: Routes.packagesScreen,
    ),
    ////
  ];
}
