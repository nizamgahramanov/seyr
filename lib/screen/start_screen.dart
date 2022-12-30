import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/screen/main_screen.dart';

import '../helper/constants.dart';
import '../helper/custom_button.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage(startScreenImage), context);
    super.didChangeDependencies();
  }

  void goToMainScreen() {
    preloadSvgFiles();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          bottomNavIndex: 0,
        ),
      ),
    );
  }

  void preloadSvgFiles() {
    Future.wait([
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, noFavoriteScreenImage),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, searchScreenImage),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, noResultFoundImage),
        null,
      ),
      precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoderBuilder, googleColorfulIconImage),
        null,
      ),
      precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoderBuilder, offlineImage),
        null,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          color: AppColors.backgroundColorOfApp,
          image: DecorationImage(
            image: AssetImage(startScreenImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppLightText(
                text: 'discover_the_land_of_fire'.tr(),
                color: AppColors.whiteColor,
                size: 32,
                fontWeight: FontWeight.bold,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 100,
              ),
              CustomButton(
                buttonText: 'get_started_btn'.tr(),
                onTap: goToMainScreen,
                borderRadius: 15,
                borderColor: AppColors.backgroundColorOfApp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
