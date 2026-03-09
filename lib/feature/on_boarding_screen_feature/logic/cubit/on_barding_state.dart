part of 'on_barding_cubit.dart';

sealed class OnBardingState {}

final class OnBardingInitial extends OnBardingState {}

class OnBardingPageChanged extends OnBardingState {}

class OnBardingCircleProgressIndicator extends OnBardingState {}

class OnBardingSkipped extends OnBardingState {}
