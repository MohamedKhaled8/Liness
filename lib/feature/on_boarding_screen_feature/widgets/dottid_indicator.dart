import 'package:flutter/widgets.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/constant/color_manger.dart';

class DottidIndicator extends StatelessWidget {
  final bool isSelected;
  const DottidIndicator({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        right: 3.w,
      ),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 500), // Corrected to milliseconds
        height: isSelected ? 2.75.h : 1.5.h,
        width: isSelected ? 5.w : 4.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? ColorsManger.white : ColorsManger.primaryColor,
        ),
      ),
    );
  }
}
