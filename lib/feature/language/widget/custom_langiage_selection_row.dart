import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first


class CustomLanguageSelectionRow extends StatelessWidget {
  final String flag;
  final String languageName;
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  const CustomLanguageSelectionRow({
    Key? key,
    required this.flag,
    required this.languageName,
    required this.value,
    required this.groupValue,
  required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(flag, style: TextStyle(fontSize: 18.sp)),
            horizintalSpace(2),
            Text(languageName, style: TextStyle(fontSize: 18.sp)),
          ],
        ),
        Radio<String>(
          value: value,
          groupValue: groupValue,
           onChanged: (String? newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
        ),
      ],
    );
  }
}
