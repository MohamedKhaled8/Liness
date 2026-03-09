import 'package:flutter/material.dart';
import 'package:liness/core/utils/config/space.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

class CustomDrobDownWidgets extends StatelessWidget {
  final String value;
  final String labelText;
  final List<String> choosedOptions;
  final void Function(String?)? onChanged;
  final IconData icon;
  const CustomDrobDownWidgets({
    Key? key,
    required this.value,
    required this.labelText,
    required this.choosedOptions,
    this.onChanged,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManger.gray),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 3.5.h,
            color: ColorsManger.mainBlue,
          ),
          horizintalSpace(3),
          Expanded(
            child: DropdownButtonFormField<String>(
              dropdownColor: ColorsManger.white,
              value: choosedOptions.contains(value) ? value : null,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: labelText,
                labelStyle:
                    TextStyle(fontSize: 18.sp, color: ColorsManger.white),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              ),
              items: choosedOptions.map((String title) {
                return DropdownMenuItem<String>(
                  value: title,
                  child: Text(
                    title,
                    style: const TextStyle(color: ColorsManger.mainBlue),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
