import 'package:liness/core/Router/export_routes.dart';
import 'package:liness/core/utils/localization/app_localization.dart';
import 'package:liness/feature/session_features/session_feature/helper/enums/session_types.dart';

String getSessionTypeFromSessionEnum({
  required SessionTypesEnum sessionTypesEnum,
  required BuildContext context,
}) {
  if (SessionTypesEnum.video == sessionTypesEnum) {
    return AppLocalizations.of(context)!.translate('video');
  } else if (SessionTypesEnum.exam == sessionTypesEnum) {
    return AppLocalizations.of(context)!.translate('exam');
  } else {
    return  AppLocalizations.of(context)!.translate('exam And video');
  }
}
