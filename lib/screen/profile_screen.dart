import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/model/firestore_user.dart';
import 'package:seyr/screen/change_name_screen.dart';
import 'package:seyr/service/auth_service.dart';
import 'package:seyr/service/firebase_firestore_service.dart';

import '../helper/constants.dart';
import '../helper/custom_button.dart';
import '../helper/custom_list_tile.dart';
import '../helper/utility.dart';
import '../provider/language.dart';
import '../helper/custom_radio_text.dart';
import 'change_email_screen.dart';
import 'change_password_screen.dart';
import 'error_and_no_network_and_favorite_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void logout() {
    Navigator.of(context).pop();
    AuthService().signOut(context);
  }

  void changeName(String firstName, String lastName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNameScreen(
          firstName: firstName,
          lastName: lastName,
        ),
      ),
    );
  }

  void changeEmail(String email, String password) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeEmailScreen(
          email: email,
          password: password,
        ),
      ),
    );
  }

  void changePassword(String email) {
    Navigator.pushNamed(context, ChangePasswordScreen.routeName,
        arguments: {'email': email});
  }

  void changeLanguage() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 230,
          child: RadioListBuilder(
            langCode: context.locale.languageCode,
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage(profileScreenImage), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        _buildTopPart(),
        Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              color: AppColors.whiteColor,
              child: StreamBuilder<FirestoreUser>(
                stream: FireStoreService().getUserDataByUID(currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    if (currentUser.providerData.first.providerId ==
                        'google.com') {
                      return Column(
                        children: [
                          CustomListTile(
                            title: 'name_title'.tr(),
                            data: 'loading_msg'.tr(),
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                          CustomListTile(
                            title: 'email_title'.tr(),
                            data: 'loading_msg'.tr(),
                          ),
                          CustomListTile(
                            title: 'language_title'.tr(),
                            data: 'loading_msg'.tr(),
                            isDividerShow: false,
                            icon: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (currentUser.providerData.first.providerId ==
                        'apple.com') {
                      return Column(
                        children: [
                          CustomListTile(
                            title: 'email_title'.tr(),
                            data: 'loading_msg'.tr(),
                          ),
                          CustomListTile(
                            title: 'language_title'.tr(),
                            data: 'loading_msg'.tr(),
                            isDividerShow: false,
                            icon: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          CustomListTile(
                            title: 'name_title'.tr(),
                            data: 'loading_msg'.tr(),
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                          CustomListTile(
                            title: 'email_title'.tr(),
                            data: 'loading_msg'.tr(),
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                          CustomListTile(
                            title: 'password_title'.tr(),
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ),
                          CustomListTile(
                            title: 'language_title'.tr(),
                            data: 'loading_msg'.tr(),
                            isDividerShow: false,
                            icon: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  } else if (snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.active ||
                      snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return ErrorAndNoNetworkAndFavoriteScreen(
                        text: "something_went_wrong_error_msg".tr(),
                        path: errorImage,
                      );
                    } else {
                      return Column(
                        children: [
                          if (snapshot.data!.firstName != null &&
                              snapshot.data!.lastName != null)
                            CustomListTile(
                              title: 'name_title'.tr(),
                              data:
                                  '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onTapFunction: () => changeName(
                                snapshot.data!.firstName!,
                                snapshot.data!.lastName!,
                              ),
                            ),
                          CustomListTile(
                            title: 'email_title'.tr(),
                            data: snapshot.data!.email,
                            icon: snapshot.data!.password == null
                                ? null
                                : const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                            onTapFunction: snapshot.data!.password == null
                                ? null
                                : () => changeEmail(snapshot.data!.email,
                                    snapshot.data!.password!),
                          ),
                          if (snapshot.data!.password != null)
                            CustomListTile(
                              title: 'password_title'.tr(),
                              icon: const Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              onTapFunction: snapshot.data!.password == null
                                  ? null
                                  : () => changePassword(snapshot.data!.email),
                            ),
                          CustomListTile(
                            title: 'language_title'.tr(),
                            data: context.locale.languageCode == 'az'
                                ? 'azerbaijani'.tr()
                                : 'english'.tr(),
                            icon: const RotatedBox(
                              quarterTurns: 1,
                              child: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                            ),
                            isDividerShow: false,
                            onTapFunction: () => changeLanguage(),
                          ),
                        ],
                      );
                    }
                  } else {
                    return ErrorAndNoNetworkAndFavoriteScreen(
                      text: "something_went_wrong_error_msg".tr(),
                      path: errorImage,
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                Utility.getInstance().showAlertDialog(
                  context: context,
                  alertTitle: 'log_out_question'.tr(),
                  popButtonColor: AppColors.backgroundColorOfApp,
                  popButtonText: 'back_btn'.tr(),
                  onPopTap: () => Navigator.of(context).pop(),
                  isShowActionButton: true,
                  actionButtonText: 'log_out_btn'.tr(),
                  onTapAction: logout,
                  actionButtonColor: AppColors.redAccent300,
                  popButtonTextColor: AppColors.blackColor,
                );
              },
              child: Container(
                color: AppColors.whiteColor,
                child: CustomListTile(
                  title: 'log_out_btn'.tr(),
                  icon: const Icon(
                    Icons.logout_rounded,
                  ),
                  isDividerShow: false,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopPart() {
    return Flexible(
      fit: FlexFit.tight,
      child: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              child: Image.asset(
                profileScreenImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: AppLightText(
              text: 'profile_title'.tr(),
              color: AppColors.whiteColor,
              size: 32,
              fontWeight: FontWeight.bold,
              spacing: 2,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class RadioListBuilder extends StatefulWidget {
  const RadioListBuilder({Key? key, required this.langCode}) : super(key: key);
  final String langCode;
  @override
  RadioListBuilderState createState() {
    return RadioListBuilderState();
  }
}

class RadioListBuilderState extends State<RadioListBuilder> {
  bool _isRadioSelected = true;
  @override
  void initState() {
    super.initState();
    if (widget.langCode == 'en') {
      _isRadioSelected = false;
    } else {
      _isRadioSelected = true;
    }
  }

  void _saveLanguage() {
    if (_isRadioSelected) {
      context.setLocale(const Locale('az', 'Latn'));
    } else {
      context.setLocale(const Locale('en', 'US'));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Language language = Provider.of<Language>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AppLightText(
          text: 'choose_language'.tr(),
          padding: const EdgeInsets.only(
            left: 25,
          ),
          size: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.blackColor,
          spacing: 0,
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return CustomRadioText(
              label: index == 0 ? 'azerbaijani'.tr() : 'english'.tr(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              value: index == 0 ? true : false,
              groupValue: _isRadioSelected,
              onChanged: (bool newValue) {
                setState(() {
                  _isRadioSelected = newValue;
                });
              },
            );
          },
          itemCount: 2,
        )),
        CustomButton(
          buttonText: 'confirm_btn'.tr(),
          borderRadius: 15,
          horizontalMargin: 20,
          onTap: () {
            _saveLanguage();
            language.onLanguageChanged();
          },
          borderColor: AppColors.primaryColorOfApp,
        ),
      ],
    );
  }
}
