import 'package:flutter/material.dart';
import '../widgets/buttons_show_in_boarding.dart';
import 'package:liness/core/widgets/local_connectivity_monitor.dart';
import 'package:liness/core/utils/function/networking_dialoge.dart';
import 'package:liness/feature/on_boarding_screen_feature/widgets/body_on_boarding_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConnectivityMonitor(
      customDisconnectedWidget: CustomDisconnectedWidget(),
      customDialog: CustomDialogConnected(),
      child: Scaffold(
        body: PopScope(
          canPop: false,
          child: Stack(
            alignment: Alignment.center,
            children: [
              BodyOnBoardingScreen(),
              Positioned(
                bottom: 0,
                child: ButtonsShowOnBarding(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
