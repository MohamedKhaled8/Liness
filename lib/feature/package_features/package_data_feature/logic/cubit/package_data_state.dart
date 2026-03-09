part of 'package_data_cubit.dart';

sealed class PackageDataState extends Equatable {
  const PackageDataState();

  @override
  List<Object> get props => [];
}

final class PackageDataInitial extends PackageDataState {}

final class PackageDataLoadingState extends PackageDataState {}

final class PackageDataLoadedState extends PackageDataState {}

final class PackageDataErrorState extends PackageDataState {}
