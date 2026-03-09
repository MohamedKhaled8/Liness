part of 'packages_cubit.dart';

sealed class PackagesState extends Equatable {
  const PackagesState();

  @override
  List<Object> get props => [];
}

final class PackagesInitial extends PackagesState {}

final class PackagesLoadingState extends PackagesState {}

final class PackagesLoadedState extends PackagesState {}

final class PackagesErrorState extends PackagesState {}
