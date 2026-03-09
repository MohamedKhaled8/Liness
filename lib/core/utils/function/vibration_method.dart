import 'package:vibration/vibration.dart';

Future<void> handleTapVibration(void Function()? tapAction) async {
  if (await Vibration.hasVibrator() ?? false) {
    Vibration.vibrate(duration: 50);
  }
  if (tapAction != null) {
    tapAction();
  }
}
