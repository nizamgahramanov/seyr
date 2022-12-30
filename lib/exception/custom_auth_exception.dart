import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../helper/app_colors.dart';
import '../helper/utility.dart';

class CustomAuthException extends FirebaseAuthException {
  CustomAuthException(BuildContext context, String code, String message)
      : super(code: code, message: message) {
    switch (code) {
      case "user-disabled":
        throw CustomException(ctx: context, errorMessage: message);
      case "invalid-email":
        throw CustomException(ctx: context, errorMessage: message);
      case "email-already-in-use":
        throw CustomException(ctx: context, errorMessage: message);
      case "weak-password":
        throw CustomException(ctx: context, errorMessage: message);
      case "operation-not-allowed":
        throw CustomException(ctx: context, errorMessage: message);
      case "auth/user-not-found":
        throw CustomException(ctx: context, errorMessage: message);
      case "auth/invalid-email":
        throw CustomException(ctx: context, errorMessage: message);
      case "account-exists-with-different-credential":
        throw CustomException(ctx: context, errorMessage: message);
      case "invalid-credential":
        throw CustomException(ctx: context, errorMessage: message);
      case "user-not-found":
        throw CustomException(ctx: context, errorMessage: message);
      case "wrong-password":
        throw CustomException(ctx: context, errorMessage: message);
      case "invalid-verification-code":
        throw CustomException(ctx: context, errorMessage: message);
      case "invalid-verification-id":
        throw CustomException(ctx: context, errorMessage: message);
    }
  }
}

class CustomException extends StatelessWidget {
  final String? errorMessage;
  final BuildContext ctx;
  const CustomException({
    required this.ctx,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Utility.getInstance().showAlertDialog(
      context: ctx,
      alertTitle: 'oops_error_title'.tr(),
      alertMessage: errorMessage,
      popButtonText: 'ok_btn'.tr(),
      popButtonColor: AppColors.redAccent300,
      onPopTap: () => Navigator.of(context).pop(),
    );
  }
}
