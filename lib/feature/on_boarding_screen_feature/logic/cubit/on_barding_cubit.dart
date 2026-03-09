import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/Router/routes.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/feature/on_boarding_screen_feature/data/model/on_barding_model.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

part 'on_barding_state.dart';

class OnBoardingCubit extends Cubit<OnBardingState> {
  OnBoardingCubit() : super(OnBardingInitial());

  PageController pageController = PageController();
  int currentIndex = 0;
  bool isLastPage = false;
  double progress = 0.1;

  List<OnBardingItemModel> items = [];

  Future<void> init(BuildContext context) async {
    try {
      items = getOnBardingItems();
      // ignore: empty_catches
    } catch (e) {}

    pageController = PageController(initialPage: 0);
    await Future.delayed(const Duration(milliseconds: 50), () {
      pageController.addListener(() {
        currentIndex = pageController.page!.round();
        isLastPageChange(currentIndex, context: context);
        updateProgress(context);
      });
    });

    emit(OnBardingInitial());
  }

  void getItems({required BuildContext context}) {
    items = getOnBardingItems();
  }

  void isLastPageChange(int index, {required BuildContext context}) {
    // if (isLastPage != (getOnBardingItems(context).length - 1 == index)) {
    //   isLastPage = getOnBardingItems(context).length - 1 == index;
    //   emit(OnBardingPageChanged());
    // }

    isLastPage = index == items.length - 1;
    // updateProgress(context);
    emit(OnBardingPageChanged());
  }

  void updateProgress(BuildContext context) {
    progress = ((currentIndex + 1) / items.length).clamp(0.01, 1.0);
    emit(OnBardingCircleProgressIndicator());
  }

  Future<void> saveSectionOnBarding(BuildContext context) async {
    await getIt<CacheHelper>().saveData(key: "onboarding", value: true);
    // ignore: use_build_context_synchronously
    context.pushReplacementNamed(Routes.loginScreen);
    emit(OnBardingInitial());
  }

  void jumpToPackage({required BuildContext context}) {
    pageController.jumpToPage(items.length - 1);
    isLastPage = true;
    emit(OnBardingSkipped());
  }

  void animateToPage(int index) {
    pageController.animateToPage(
      index,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
    emit(OnBardingPageChanged());
  }

  void nextToPage(BuildContext context) {
    if (currentIndex < items.length - 1) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      saveSectionOnBarding(context);
    }
    emit(OnBardingPageChanged());
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
