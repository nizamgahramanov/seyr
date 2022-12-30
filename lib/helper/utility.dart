import 'package:flutter/material.dart';
import 'package:seyr/helper/custom_alert_dialog.dart';

class Utility {
  static Utility? utility;

  static Utility getInstance() {
    utility ??= Utility();
    return utility!;
  }


  showAlertDialog({
    required BuildContext context,
    required String alertTitle,
    final String? alertMessage,
    required String popButtonText,
    required Color popButtonColor,
    required VoidCallback onPopTap,
    final bool? isShowActionButton,
    final String? actionButtonText,
    final VoidCallback? onTapAction,
    final Color? actionButtonColor,
    final Color? popButtonTextColor,
  }) {
    // set up the AlertDialog
    CustomAlertDialog alert = CustomAlertDialog(
      title: alertTitle,
      description: alertMessage,
      popButtonText: popButtonText,
      popButtonColor:popButtonColor,
      onPopTap: onPopTap,
      isShowActionButton: isShowActionButton,
      actionButtonText: actionButtonText,
      onTapAction: onTapAction,
      actionButtonColor: actionButtonColor,
      popButtonTextColor:popButtonTextColor ,
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
