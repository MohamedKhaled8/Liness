import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liness/core/utils/constant/image_assets_manger.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/core/utils/constant/change_translate_and_theme.dart';
import 'package:liness/feature/subject_feature/data/model/subject_model.dart';
import 'package:liness/feature/subject_feature/data/repository/subject_repository.dart';
import 'package:liness/core/utils/widgets/course_and_session_widget/model/course_and_session_card_model.dart';
part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectRepository subjectRepository;
  final PageController pageController = PageController(viewportFraction: 0.8);

  /// قايمة كده بخزن فيها الداتا القديمة بدل ما أروح واجبها تاني
  List<SubjectModel>? _subjects;
  SubjectCubit({required this.subjectRepository}) : super(SubjectInitial());
  bool isArabic = ChangeTranslateAndTheme.isArabic;
  bool _showOriginalText = false;

  bool get showOriginalText => _showOriginalText;

  final List<String> images = [
    ImageAssetsManger.subjecttwo,
    ImageAssetsManger.subjetcone,
  ];

  void toggleShowOriginalText() {
    _showOriginalText = true;
    emit(ToggleShowOriginalTextInitial(_showOriginalText));
  }

  Future<void> getSubjects({
    required BuildContext context,
  }) async {
    if (isClosed) return;

    ///بتأكد ان الداتا مش فارغة
    if (_subjects != null && _subjects!.isNotEmpty) {
      // emit(SubjectLoaded(_subjects!));
      return;
    }

    emit(const SubjectLoading());

    final result = await subjectRepository.fetchSubjects();
    result.fold(
      (errMessage) {
        if (!isClosed) emit(SubjectError());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (subjects) {
        _subjects = subjects;
        if (!isClosed) emit(SubjectLoaded(subjects));
      },
    );
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
