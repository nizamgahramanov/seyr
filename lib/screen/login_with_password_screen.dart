import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/utility.dart';
import 'package:seyr/screen/change_password_screen.dart';
import 'package:seyr/service/auth_service.dart';
import 'package:seyr/service/en_de_cryption.dart';
import 'package:seyr/service/firebase_firestore_service.dart';

import '../helper/app_colors.dart';
import '../helper/custom_button.dart';
import '../helper/custom_nested_scroll_view.dart';
import '../helper/custom_text_form_field.dart';
import 'main_screen.dart';

class LoginWithPasswordScreen extends StatefulWidget {
  static const routeName = '/login_with_password';

  String? password;

  LoginWithPasswordScreen({key}) : super(key: key);

  @override
  State<LoginWithPasswordScreen> createState() =>
      _LoginWithPasswordScreenState();
}

class _LoginWithPasswordScreenState extends State<LoginWithPasswordScreen> {
  final _loginWithPasswordForm = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  bool _isObscure = true;
  bool _isShowDoneButton = false;

  void saveForm() {
    //check in firebase email is registered or not
    FocusScope.of(context).unfocus();
    _loginWithPasswordForm.currentState!.save();
  }

  void checkIfPasswordChanged(String text) {
    if (_passwordController.text != '') {
      setState(() {
        _isShowDoneButton = true;
      });
    } else {
      setState(() {
        _isShowDoneButton = false;
      });
    }
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void _goProfileScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          bottomNavIndex: 3,
        ),
      ),
      (Route<dynamic> route) => false,
    );
    // Navigator.pushNamedAndRemoveUntil(
    //     context, MainScreen.routeName, (route) => false);
  }

  void goForgotPasswordScreen(String email) {
    Navigator.pushNamed(context, ChangePasswordScreen.routeName,
        arguments: {'email': email});
  }

  void checkPasswordCorrect(context, email, enteredPassword) async {
    //    1. Daxil olan userin emailinə vasitəsi ilə firestoredan məlumatlarını çəkirik
    //    2. Melumatlarda encrypt olunmuş passvordu decrypt edib userin daxil etiyi passvordla yoxlayiriq
    //    3. userin daxil etdiyi passvord dogrudursa home page yoneldirik
    //    4. dogru deyilse dialog gosteririk
    if (_isShowDoneButton) {
      final String? base16Encrypted =
          await FireStoreService().getUserPasswordFromFirestore(email);
      bool isPasswordCorrect =
          EnDeCryption().isPasswordCorrect(enteredPassword, base16Encrypted!);
      if (isPasswordCorrect) {
        await AuthService().loginUser(
          context: context,
          email: email,
          password: enteredPassword,
        );
        _goProfileScreen();
      } else {
        Utility.getInstance().showAlertDialog(
            popButtonColor: AppColors.backgroundColorOfApp,
            context: context,
            alertTitle: 'password_is_not_correct_dialog_msg'.tr(),
            alertMessage: 'please_check_and_try_again_dialog_msg'.tr(),
            popButtonText: 'back_btn'.tr(),
            onPopTap: () => Navigator.of(context).pop(),
            popButtonTextColor: AppColors.blackColor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'welcome_back_title'.tr(),
        child: Form(
          key: _loginWithPasswordForm,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              AppLightText(
                text: 'current_password_title'.tr(),
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
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                obscureText: _isObscure,
                suffixIcon: GestureDetector(
                  onTap: () => _toggleObscure(),
                  child: _isObscure
                      ? const Icon(Icons.remove_red_eye_outlined)
                      : const Icon(Icons.remove_red_eye),
                ),
                onChanged: (value) => checkIfPasswordChanged(value),
                onFieldSubmitted: (_) => saveForm(),
                onSaved: (value) =>
                    checkPasswordCorrect(context, args['email'], value),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _isShowDoneButton
          ? CustomButton(
              buttonText: 'done_btn'.tr(),
              borderRadius: 15,
              horizontalMargin: 20,
              onTap: saveForm,
              borderColor: AppColors.primaryColorOfApp,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
