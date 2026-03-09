import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liness/core/utils/helper/extensions.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/helper/image_source_bottom_sheet_helper.dart';
import 'package:liness/feature/profile_features/main_profile_feature/logic/cubit/profile_cubit.dart';

class SelectProfilePhotoWidget extends StatelessWidget {
  const SelectProfilePhotoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ////
    final profileCubit = context.read<ProfileCubit>();
    ////

    return Stack(
      children: [
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return CircleAvatar(
              radius: 35.sp,
              backgroundImage: profileCubit.profileImage != null
                  ? FileImage(File(profileCubit.profileImage!))
                  : null,
            );
          },
        ),
        Positioned(
          bottom: 0.sp,
          right: 0.sp,
          child: Container(
            width: 10.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: ColorsManger.black),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0.sp),
                      topRight: Radius.circular(20.0.sp),
                    ),
                  ),
                  builder: (context) => ImageSourceBottomSheetHelper(
                    onCameraTap: () {
                      context.pop();
                      profileCubit.selectImage(ImageSource.camera);
                    },
                    onGalleryTap: () {
                      context.pop();
                      profileCubit.selectImage(ImageSource.gallery);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
