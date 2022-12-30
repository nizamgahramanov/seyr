import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyr/screen/profile_screen.dart';
import '../helper/app_colors.dart';
import '../provider/language.dart';
import 'algolia_search_screen.dart';
import 'favorite_screen.dart';
import 'home_screen.dart';
import 'login_signup_screen.dart';

class Wrapper extends StatefulWidget {
  final bool isLogin;
  int? bottomNavIndex;

  static const routeName = '/wrapper';
  Wrapper({
    Key? key,
    required this.isLogin,
    this.bottomNavIndex,
  }) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with SingleTickerProviderStateMixin {
  void _onItemTapped(int index) {
    setState(() {
      widget.bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Language>(context);
    Map<int, Widget> screens = {
      0: HomeScreen(isLogin: widget.isLogin),
      1: const AlgoliaSearchScreen(),
      2: FavoriteScreen(),
      3: widget.isLogin ? ProfileScreen() : const LoginSignupScreen(),
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColorOfApp,
      body: screens[widget.bottomNavIndex]!,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: widget.bottomNavIndex == 0
                ? const Icon(
                    Icons.home,
                  )
                : const Icon(
                    Icons.home_outlined,
                  ),
            label: 'home_bottom_nav_bar'.tr(),
          ),
          BottomNavigationBarItem(
            icon: widget.bottomNavIndex == 1
                ? const Icon(
                    Icons.saved_search_outlined,
                  )
                : const Icon(
                    Icons.search,
                  ),
            label: 'search_bottom_nav_bar'.tr(),
          ),
          BottomNavigationBarItem(
            icon: widget.bottomNavIndex == 2
                ? const Icon(
                    Icons.favorite_rounded,
                  )
                : const Icon(
                    Icons.favorite_border_outlined,
                  ),
            label: 'favorite_bottom_nav_bar'.tr(),
          ),
          BottomNavigationBarItem(
            icon: widget.isLogin
                ? widget.bottomNavIndex == 3
                    ? const Icon(
                        Icons.person,
                      )
                    : const Icon(
                        Icons.person_outline_rounded,
                      )
                : widget.bottomNavIndex == 3
                    ? const Icon(
                        Icons.login,
                      )
                    : const Icon(
                        Icons.login_outlined,
                      ),
            label: widget.isLogin
                ? 'profile_bottom_nav_bar'.tr()
                : 'login_bottom_nav_bar'.tr(),
          ),
        ],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.bottomNavIndex ?? 0,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedItemColor: AppColors.primaryColorOfApp,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: AppColors.blackColor38,
      ),
    );
  }
}
