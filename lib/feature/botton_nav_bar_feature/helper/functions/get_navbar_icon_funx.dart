import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

IconData getNavBarIcon(int index) {
  switch (index) {
    case 0:
      return Iconsax.home;
    case 1:
      return Iconsax.tag;
    case 2:
      return Iconsax.book;
    case 3:
      return Iconsax.teacher;
    default:
      return Iconsax.home; // Default icon
  }
}
