import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_button.dart';
import 'package:seyr/provider/destinations.dart';
import 'package:seyr/widget/staggered_grid_view.dart';

import 'add_destination_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.isLogin, Key? key}) : super(key: key);
  final bool isLogin;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  void _goAddDestinationScreen() {
    Navigator.of(context).pushNamed(AddDestinationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Destinations>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
          bottom: 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: AppLightText(
                    text: 'home_title'.tr(),
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.bold,
                    spacing: 0,
                    padding: EdgeInsets.zero,
                    size: 20,
                    alignment: Alignment.centerLeft,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                  ),
                ),
                if (widget.isLogin)
                  CustomButton(
                    onTap: _goAddDestinationScreen,
                    buttonText: 'home_add_btn'.tr(),
                    borderRadius: 15,
                    buttonTextSize: 13,
                    height: 45,
                    buttonColor: AppColors.primaryColorOfApp,
                    textColor: AppColors.whiteColor,
                    borderColor: AppColors.primaryColorOfApp,
                    textPadding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StaggeredGridView(),
            ),
          ],
        ),
      ),
    );
  }
}
