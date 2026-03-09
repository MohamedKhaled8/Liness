import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class BottomNavBarModel {
  final String name;
  final IconData icon;
  BottomNavBarModel({
    required this.name,
    required this.icon,
  });
}

List<BottomNavBarModel> bootmNavBarModel = [
  BottomNavBarModel(name: "Home", icon: Iconsax.home),
  BottomNavBarModel(name: "subJect", icon: Iconsax.subtitle),
  BottomNavBarModel(name: "Course", icon: Iconsax.activity),
  BottomNavBarModel(name: "Teacher", icon: Iconsax.teacher),
];
