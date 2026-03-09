abstract class VideoState {}

class VideoInitState extends VideoState {}

final class VideoLoadingState extends VideoState {}

final class VideoGetDataSuccessState extends VideoState {}

final class VideoLoadedState extends VideoState {}

final class VideoErrorState extends VideoState {}
class VideoDhikrUpdatedState extends VideoState {
  final int currentAdhkarIndex;

  VideoDhikrUpdatedState({required this.currentAdhkarIndex});
}