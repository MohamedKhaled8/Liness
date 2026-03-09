import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/repos/packages_repo.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:liness/feature/home/data/model/image_model.dart';
import 'package:liness/feature/home/data/model/session_resent_model.dart';
import 'package:liness/feature/home/data/repository/home_repository.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';
import 'package:liness/core/utils/widgets/custom_teacher_card_widget/model/teacher_card_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final _carouselController = CarouselSliderController();
  final _carouselControllerCards = CarouselSliderController();
  final HomeRepository _repository = HomeRepository();

  int currentIndex = 0;
  final int _currentIndexCards = 0;
  // ignore: unused_field
  int _activeIndex = 0;
  bool _showBothTexts = false;
  List<ImageModel> images = [];
  List<TeacherCardModel> teachers = [];
  List<SessionResentModel> recentSessions = [];
  List<PackageModel> packagesModelList = [];

  get carouselController => _carouselController;
  get carouselControllerCards => _carouselControllerCards;
  int get currentIndexCards => _currentIndexCards;
  int activeIndex = 0;

  bool get showBothTexts => _showBothTexts;

  // PageController pageController = PageController(initialPage: 0);

  void changePage(int index) {
    currentIndex = index;
    // pageController.jumpToPage(index);
    emit(PageChangedState());
  }

  void changeIndexClicked(int index) {
    _activeIndex = index;
    emit(PageChangedState());
  }

  Future<void> loadImages() async {
    if (isClosed) return;
    emit(HomeLoadingState());
    final result = await HomeRepository().fetchImages();

    result.fold(
      (errMessage) {
        if (!isClosed) emit(HomeErrorState());
      },
      (imagesList) {
        // تحديث الصور فقط عند اختلافها عن الحالية
        if (images.isEmpty || !_areImagesEqual(images, imagesList)) {
          images = imagesList;
          if (!isClosed) emit(ImagesLoadedState());
        }
      },
    );
  }

  bool _areImagesEqual(List<ImageModel> oldImages, List<ImageModel> newImages) {
    if (oldImages.length != newImages.length) return false;
    for (int i = 0; i < oldImages.length; i++) {
      if (oldImages[i].imageUrl != newImages[i].imageUrl) return false;
    }
    return true;
  }

  Future<void> loadTeachers() async {
    if (isClosed) return;
    emit(HomeLoadingState());

    final result = await _repository.fetchTeachers();

    result.fold(
      (errMessage) {
        if (!isClosed) emit(HomeErrorState());
        // showLocalizedMessage(
        //   context,
        //   errMessage.msgAr,
        //   errMessage.msgEn,
        //   isError: true,
        // );
      },
      (teachersList) {
        teachers = teachersList;
        if (!isClosed) emit(TeachersLoadedState());
      },
    );
  }

  Future<void> loadSessionResent() async {
    if (isClosed) return;
    emit(HomeLoadingState());
    final result = await _repository.fetchSessionResent();
    result.fold(
      (errMessage) {
        if (!isClosed) emit(HomeErrorState());
        // showLocalizedMessage(
        //   context,
        //   errMessage.msgAr,
        //   errMessage.msgEn,
        //   isError: true,
        // );
      },
      (sessions) {
        recentSessions = sessions;
        if (!isClosed) emit(SessionResentLoadedState());
      },
    );
  }

  Future<void> getPackagesData() async {
    if (isClosed) return;
    emit(HomeLoadingState());

    final result = await PackagesRepository.getPackagesData();

    result.fold(
      (errMessage) {
        if (!isClosed) emit(HomeErrorState());
        // showLocalizedMessage(
        //   context,
        //   errMessage.msgAr,
        //   errMessage.msgEn,
        //   isError: true,
        // );
      },
      (packagesModelList) {
        ////
        this.packagesModelList = packagesModelList;
        ////
        if (!isClosed) emit(HomeGetPackagesDataSuccesssState());
        ////
      },
    );
  }

  void showTexts() {
    emit(ShowHelloTextState());
  }

  void finishAnimation() {
    _showBothTexts = true;
    emit(ShowBothTextsState());
  }

  void startNextAnimation() {
    emit(ShowBothTextsState());
  }
}
