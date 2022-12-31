import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_text_form_field.dart';
import 'package:seyr/screen/password_screen.dart';
import 'package:seyr/service/auth_service.dart';

import '../helper/constants.dart';
import '../helper/custom_button.dart';
import '../helper/utility.dart';
import '../service/firebase_firestore_service.dart';
import 'login_with_password_screen.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);
  static const routeName = '/login_signup';
  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _form = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isShowSaveButton = false;
  bool _isDisableContinueButton = false;
  bool _isDisableGoogleButton = false;

  void checkIfEmailChanged(String character) {
    if (_emailController.text != '' &&
        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
            .hasMatch(_emailController.text)) {
      setState(() {
        _isShowSaveButton = true;
      });
    } else {
      setState(() {
        if (_isShowSaveButton) {
          _isShowSaveButton = false;
        }
      });
    }
  }

  void directNextScreen(
    List<String> isEmailExistList,
    String? base16Encrypted,
    String value,
  ) {
    bool provider = false;
    Map<String, dynamic> arguments = {"provider": provider, "email": value};
    if (isEmailExistList.isNotEmpty && base16Encrypted == null) {
      setState(() {
        _isDisableContinueButton = false;
      });
      Utility.getInstance().showAlertDialog(
        popButtonColor: AppColors.redAccent300,
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'there_is_a_discrepancy_on_email_dialog_msg'.tr(),
        popButtonText: 'ok_btn'.tr(),
        onPopTap: () => Navigator.of(context).pop(),
      );
    } else {
      if (isEmailExistList.isEmpty) {
        //  go to password page
        setState(() {
          _isDisableContinueButton = false;
        });
        Navigator.pushNamed(
          context,
          PasswordScreen.routeName,
          arguments: arguments,
        );
      } else {
        provider = true;
        if (isEmailExistList[0] == "google.com") {
          setState(() {
            _isDisableContinueButton = false;
          });
          AuthService().signInWithGoogle(context);
        } else {
          setState(() {
            _isDisableContinueButton = false;
          });
          Navigator.pushNamed(
            context,
            LoginWithPasswordScreen.routeName,
            arguments: arguments,
          );
        }
      }
    }
  }

  void signInWithGoogle() async {
    setState(() {
      _isDisableGoogleButton = true;
    });
    await AuthService().signInWithGoogle(context);
    setState(() {
      _isDisableGoogleButton = false;
    });
  }

  void saveForm() {
    FocusScope.of(context).unfocus();
    _form.currentState!.save();
  }

  void checkEmailIsRegistered(String value) async {
    if (_isShowSaveButton) {
      setState(() {
        _isDisableContinueButton = true;
      });
      List<String> isEmailExistList;
      isEmailExistList = await _auth.fetchSignInMethodsForEmail(value.trim());
      final String? base16Encrypted =
          await FireStoreService().getUserPasswordFromFirestore(value);
      directNextScreen(isEmailExistList, base16Encrypted, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        // heightFactor: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _form,
              child: Column(
                children: [
                  AppLightText(
                    text: 'email_title'.tr(),
                    size: 18,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                    spacing: 2,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: (character) => checkIfEmailChanged(character),
                    onFieldSubmitted: (_) {
                      saveForm();
                    },
                    onSaved: (value) {
                      checkEmailIsRegistered(value);
                    },
                  ),
                  if (_isShowSaveButton)
                    const SizedBox(
                      height: 30,
                    ),
                  if (_isShowSaveButton)
                    CustomButton(
                      buttonText: 'continue_btn'.tr(),
                      // onTap: saveForm,
                      onTap: _isDisableContinueButton ? () {} : saveForm,
                      borderRadius: 15,
                      borderColor: AppColors.primaryColorOfApp,
                    ),
                  Row(
                    children: <Widget>[
                      const Expanded(
                        child: Divider(
                          height: 70,
                          indent: 20,
                          endIndent: 10,
                          thickness: 1.5,
                        ),
                      ),
                      AppLightText(
                        spacing: 16,
                        text: 'or_divider'.tr(),
                        size: 12,
                        color: AppColors.primaryColorOfApp,
                        padding: EdgeInsets.zero,
                      ),
                      const Expanded(
                        child: Divider(
                          height: 70,
                          indent: 10,
                          endIndent: 20,
                          thickness: 1.5,
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    buttonText: 'continue_with_google_btn'.tr(),
                    borderColor: AppColors.primaryColorOfApp,
                    onTap: _isDisableGoogleButton ? () {} : signInWithGoogle,
                    borderRadius: 15,
                    buttonColor: Colors.transparent,
                    textColor: AppColors.primaryColorOfApp,
                    icon: Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(right: 25),
                      child: SvgPicture.asset(googleColorfulIconImage),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
