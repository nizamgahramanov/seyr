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
  void _onTapToListTile(int index, FirestoreUser? user) {
    if (user != null) {
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNameScreen(
              firstName: user.firstName!,
              lastName: user.lastName!,
            ),
          ),
        );
      } else if (index == 1) {
        if (user.password != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeEmailScreen(
                email: user.email,
                password: user.password,
              ),
            ),
          );
        }
      } else if (index == 2) {
        Navigator.pushNamed(context, ChangePasswordScreen.routeName,
            arguments: {'email': user.email});
      } else {
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
    }
  }

  String? _changeDataByIndex(int index, FirestoreUser? user) {
    if (user != null) {
      if (index == 0) {
        return '${user.firstName!} ${user.lastName!}';
      } else if (index == 1) {
        return user.email;
      } else if (index == 2) {
        return null;
      } else {
        return context.locale.languageCode == 'az'
            ? 'azerbaijani'.tr()
            : 'english'.tr();
      }
    }
    return null;
  }

  Widget? _getIcon(int index, FirestoreUser? user) {
    if (index == 1) {
      if (user!.password != null) {
        return const Icon(
          Icons.arrow_forward_ios_outlined,
        );
      }
    } else if (index == 3) {
      return const RotatedBox(
        quarterTurns: 1,
        child: Icon(
          Icons.arrow_forward_ios_outlined,
        ),
      );
    } else {
      return const Icon(
        Icons.arrow_forward_ios_outlined,
      );
    }
    return null;
  }

  void logout() {
    Navigator.of(context).pop();
    AuthService().signOut(context);
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage(profileScreenImage), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    User? result = FirebaseAuth.instance.currentUser;

    final List titleList = [
      'name_title'.tr(),
      'email_title'.tr(),
      'password_title'.tr(),
      'language_title'.tr(),
    ];
    return Column(
      children: [
        Flexible(
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
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 50,
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
        ),
        Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Container(
              color: AppColors.whiteColor,
              child: StreamBuilder<FirestoreUser>(
                  stream: FireStoreService().getUserDataByUID(result!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: titleList.length,
                        itemBuilder: (BuildContext context, int index) =>
                            CustomListTile(
                          title: titleList[index],
                          data: index != 2 ? 'loading_msg'.tr() : null,
                          icon: index == 3
                              ? const RotatedBox(
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                        ),
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          color: AppColors.primaryColorOfApp,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return ErrorAndNoNetworkAndFavoriteScreen(
                          text: "something_went_wrong_error_msg".tr(),
                          path: errorImage,
                        );
                      } else {
                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: titleList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () => _onTapToListTile(
                              index,
                              snapshot.data,
                            ),
                            behavior: HitTestBehavior.translucent,
                            child: snapshot.data!.password == null && index == 2
                                ? null
                                : CustomListTile(
                                    title: titleList[index],
                                    data: _changeDataByIndex(
                                      index,
                                      snapshot.data,
                                    ),
                                    icon: _getIcon(index, snapshot.data),
                                  ),
                          ),
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                            color: AppColors.primaryColorOfApp,
                          ),
                        );
                      }
                    } else {
                      return ErrorAndNoNetworkAndFavoriteScreen(
                        text: "something_went_wrong_error_msg".tr(),
                        path: errorImage,
                      );
                    }
                  }),
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
