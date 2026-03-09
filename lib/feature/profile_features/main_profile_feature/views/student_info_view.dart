import 'package:flutter/material.dart';
import 'package:liness/core/utils/constant/global_data.dart';
import 'package:liness/core/utils/constant/style_manger.dart';
import 'package:liness/core/utils/localization/app_localization.dart';

class StudentInfoView extends StatelessWidget {
  const StudentInfoView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            gLoginUserModel?.email ??
                AppLocalizations.of(context)!.translate('Email is Empty'),
            style: StylesManager.textStyle16None,
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Text(
            "${AppLocalizations.of(context)!.translate('Phone')}: ${gLoginUserModel?.phone ?? AppLocalizations.of(context)!.translate('Phone is Empty')}",
            style: StylesManager.textStyle16None,
          ),
        ),
        Center(
          child: Text(
            "${AppLocalizations.of(context)!.translate('User Code')}: ${gLoginUserModel?.code ?? AppLocalizations.of(context)!.translate('Code is Empty')}",
            style: StylesManager.textStyle16None,
          ),
        ),
      ],
    );
  }
}
