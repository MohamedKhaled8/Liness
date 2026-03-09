import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
// ignore: file_names

IconData getIcon(int index) {
  switch (index) {
    case 0:
      return Iconsax.home;
    case 1:
      return Iconsax.tag;
    case 2:
      return Iconsax.book;
    case 3:
      return Iconsax.teacher;
    case 4:
      return Iconsax.box;
    default:
      return Iconsax.home; // Default icon
  }
}

String getLabel(int index, BuildContext context) {
  switch (index) {
    case 0:
      return AppLocalizations.of(context)!.translate('Home');
    case 1:
      return AppLocalizations.of(context)!.translate('Subject');
    case 2:
      return AppLocalizations.of(context)!.translate('Course');
    case 3:
      return AppLocalizations.of(context)!.translate('Teacher');
    case 4:
      return AppLocalizations.of(context)!.translate('Packages');
    default:
      return AppLocalizations.of(context)!.translate('Home');
  }
}
