import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seyr/screen/error_and_no_network_and_favorite_screen.dart';
import 'package:seyr/service/network_service.dart';

import '../helper/constants.dart';

class NetworkConnectionChecker extends StatelessWidget {
  final Widget child;
  const NetworkConnectionChecker({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkStatus = Provider.of<NetworkStatus>(context);

    return Container(
      child: networkStatus == NetworkStatus.online
          ? child
          : Center(
              child: ErrorAndNoNetworkAndFavoriteScreen(
                text: 'no_internet_connection_msg'.tr(),
                path: offlineImage,
                height: 350,
                width: 350,
              ),
            ),
    );
  }
}
