import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/feature/session_features/exam_feature/ui/views/session_code_dialog_view.dart';

Future<void> showCodeDialog({
  required BuildContext context,
  required Function(String) onSubmit,
}) async {
  String code = '';

  await showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (BuildContext buildContext, Animation animation,
        Animation secondaryAnimation) {
      return Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SessionCodeDialog(
                      onChanged: (value) {
                        code = value;
                      },
                      onSubmit: () async {
                        if (code.isNotEmpty) {
                          onSubmit(code);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter a valid code'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
