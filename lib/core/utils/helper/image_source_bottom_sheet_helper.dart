import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/constant/style_manger.dart';

class ImageSourceBottomSheetHelper extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;

  const ImageSourceBottomSheetHelper({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: ColorsManger.mainBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Select Image Source',
              style: StylesManager.textStyle18Bold(context)),
          verticalSpace(2),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: ColorsManger.white),
            title: const Text(
              'Camera',
              style: TextStyle(color: ColorsManger.white),
            ),
            onTap: onCameraTap,
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: ColorsManger.white),
            title: const Text(
              'Gallery',
              style: TextStyle(color: ColorsManger.white),
            ),
            onTap: onGalleryTap,
          ),
        ],
      ),
    );
  }
}
