import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:seyr/model/user.dart' as app;
import 'package:seyr/screen/wrapper.dart';
import 'package:seyr/service/auth_service.dart';

import '../helper/app_colors.dart';

class MainScreen extends StatefulWidget {
  int? bottomNavIndex;

  MainScreen({
    Key? key,
    required this.bottomNavIndex,
  }) : super(key: key);
  static const routeName = '/main';
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<app.User?>(
        stream: authService.user,
        builder: (
          _,
          AsyncSnapshot<app.User?> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.active) {
            final app.User? user = snapshot.data;
            return user == null
                ? Wrapper(
                    isLogin: false,
                    bottomNavIndex: widget.bottomNavIndex,
                  )
                : Wrapper(
                    isLogin: true,
                    bottomNavIndex: widget.bottomNavIndex,
                  );
          } else {
            return const Scaffold(
              body: Center(
                child: SpinKitThreeBounce(
                  color: AppColors.primaryColorOfApp,
                  size: 25.0,
                ),
              ),
            );
          }
        });
  }
}
