import 'package:flutter/material.dart';
import 'package:liness/core/utils/constant/style_manger.dart';

class TitleCards extends StatelessWidget {
  final String title;
  final String subTitle;
  const TitleCards({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: StylesManager.textStyle18None.copyWith(fontSize: 18)),
          Text(
            subTitle,
            style: StylesManager.textStyle16Gray(context),
          ),
        ],
      ),
    );
  }
}
