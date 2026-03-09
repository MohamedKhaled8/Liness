import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

String getNavbarLabel(int index, BuildContext context) {
  switch (index) {
    case 0:
      return AppLocalizations.of(context)!.translate('Home');
    case 1:
      return AppLocalizations.of(context)!.translate('Subject');
    case 2:
      return AppLocalizations.of(context)!.translate('Course');
    case 3:
      return AppLocalizations.of(context)!.translate('Teacher');
    default:
      return AppLocalizations.of(context)!.translate('Home');
  }
}
