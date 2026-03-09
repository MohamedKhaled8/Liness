import 'package:flutter/material.dart';
import 'package:screen_go/extensions/responsive_nums.dart';
import 'package:liness/core/utils/function/luncher_url.dart';
import 'package:liness/core/utils/constant/color_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class DownloadButtonWidget extends StatefulWidget {
  final String fileName;
  final String fileLink;

  const DownloadButtonWidget({
    Key? key,
    required this.fileName,
    required this.fileLink,
  }) : super(key: key);

  @override
  State<DownloadButtonWidget> createState() => _DownloadButtonWidgetState();
}

class _DownloadButtonWidgetState extends State<DownloadButtonWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3000),
  );

  late final Animation<double> progress =
      Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: controller, curve: Curves.easeInOut),
  );

  bool isDownloading = false;

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        controller.reset();
        setState(() => isDownloading = false);
        await launchURL(widget.fileLink);
      }
    });
  }

  void startDownload() {
    setState(() => isDownloading = true);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: startDownload,
      child: AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Background container
              Container(
                width: 45.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: ColorsManger.mainBlue,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: isDownloading
                      ? const SizedBox.shrink()
                      : Text(
                          AppLocalizations.of(context)!
                              .translate('Download File'),
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: ColorsManger.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              // Circular loading indicator and icon
              if (isDownloading) ...[
                CircularProgressIndicator(
                  value: progress.value,
                  color: ColorsManger.white,
                  strokeWidth: 4.0,
                ),
                Icon(
                  Icons.download_for_offline,
                  color: ColorsManger.white,
                  size: 23.sp,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
