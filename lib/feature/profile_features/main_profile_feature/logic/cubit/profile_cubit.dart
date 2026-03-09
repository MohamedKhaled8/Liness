import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/model/api/profile_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:liness/core/utils/dependency/get_it.dart';
import 'package:liness/core/utils/helper/cash_helper.dart';
import 'package:liness/core/utils/function/show_localized_message.dart';
import 'package:liness/feature/profile_features/main_profile_feature/data/repository/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  final ProfileRepository profileRepository = getIt<ProfileRepository>();

  final ImagePicker _picker = ImagePicker();

  String? profileImage;

  ProfileModel? profileModel;

  //// SELECT PROFILE IMAGE
  Future<void> selectImage(ImageSource source) async {
    try {
      ////
      final XFile? pickedFile = await _picker.pickImage(source: source);
      ////
      if (pickedFile != null) {
        ////
        final directory = await getApplicationDocumentsDirectory();
        ////
        final path = directory.path;
        ////
        final fileName = basename(pickedFile.path);
        ////
        final File localImage =
            await File(pickedFile.path).copy('$path/$fileName');
        ////
        profileImage = localImage.path;
        ////
        await getIt<CacheHelper>()
            .saveData(key: 'profile_image', value: localImage.path);
        ////
        emit(ProfileImageChanged());
        ////
      }
    } catch (e) {
      emit(ProfileError());
    }
  }

  //// GET PROFILE CACHED IMAGE
  void loadCachedImage() {
    profileImage = getIt<CacheHelper>().getDataString(key: 'profile_image');
  }

  //// GET PROFILE DATA REQUEST
  Future<void> getProfileData({
    required BuildContext context,
  }) async {
    emit(ProfileLoading());
    final result = await profileRepository.getProfileData();

    result.fold(
      (errMessage) {
        emit(ProfileError());

        ///
        showLocalizedMessage(
          context,
          errMessage.msgAr,
          errMessage.msgEn,
          isError: true,
        );

        ///
      },
      (profileModel) {
        ////
        this.profileModel = profileModel;
        ////
        emit(ProfileLoaded());
        ////
      },
    );
  }
}
