import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/widgets/package_widget.dart';
import 'package:liness/feature/package_features/all_packages_feature/models/package_model.dart';

class PackageSlideInCard extends StatefulWidget {
  final int index; // فهرس البطاقة
  final PackageModel packageModel; // نموذج الحزمة

  const PackageSlideInCard({
    Key? key,
    required this.index,
    required this.packageModel,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PackageSlideInCardState createState() => _PackageSlideInCardState();
}

class _PackageSlideInCardState extends State<PackageSlideInCard>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      _controller.forward();
    });

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: InkWell(
        onTap: () {},
        child: PackageWidget(
          widthImage: 55.w,
          heightImage: 23.h,
          imageFit: BoxFit.fill,
          packageModel: widget.packageModel,
        ),
      ),
    );
  }
}
