import 'package:liness/core/utils/config/space.dart';
import 'package:liness/core/Router/export_routes.dart';
import 'package:screen_go/extensions/responsive_nums.dart';

class CustomDialogConnected extends StatelessWidget {
  const CustomDialogConnected({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      contentPadding: const EdgeInsets.all(20),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.redAccent.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: Colors.redAccent,
            ),
          ),
          horizintalSpace(5),
          Text(
            'Connection Lost',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: Text(
        'It looks like you’re offline. Please check your internet connection and try again to continue.',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CustomDisconnectedWidget extends StatelessWidget {
  const CustomDisconnectedWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: Colors.redAccent,
              size: 100,
            ),
            SizedBox(height: 10.h),
            Text(
              'No Internet Connection!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 7.h),
            Text(
              'You are currently offline. Check your internet connection and try again.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
