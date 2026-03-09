part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

final class HomeGetPackagesDataSuccesssState extends HomeState {}

class PageChangedState extends HomeState {}

class ShowButtonsState extends HomeState {
  final bool showButtons;

  const ShowButtonsState(this.showButtons);
}

class ActiveChangeIndex extends HomeState {
  final int activeIndex;

  const ActiveChangeIndex(this.activeIndex);
}

class HomeScrollPositionChanged extends HomeState {
  final double offset;
  const HomeScrollPositionChanged(this.offset);
}

class ImagesLoadedState extends HomeState {}

class HomeErrorState extends HomeState {}

class HomeLoadingState extends HomeState {}

class TeachersLoadedState extends HomeState {}

// Add this state to your HomeState class
class SessionResentLoadedState extends HomeState {}

class ShowHelloTextState extends HomeState {}

class ShowBothTextsState extends HomeState {}
