part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileImageChanged extends ProfileState {
  // final File imageFile;
  // const ProfileImageChanged(this.imageFile);

  @override
  List<Object> get props => [];
}

class ProfileError extends ProfileState {

}

class ProfileLoaded extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUnauthorized extends ProfileState {
  final String message;

  const ProfileUnauthorized(this.message);

  @override
  List<Object> get props => [message];
}
