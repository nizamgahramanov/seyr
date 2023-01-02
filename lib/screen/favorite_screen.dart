import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seyr/service/firebase_firestore_service.dart';
import 'package:seyr/widget/network_connection_checker.dart';

import '../helper/constants.dart';
import '../model/destination.dart';
import '../widget/spinner.dart';
import '../widget/staggered_grid_item.dart';
import 'detail_screen.dart';
import 'error_and_no_network_and_favorite_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance.currentUser;
  FavoriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NetworkConnectionChecker(
      child: _firebaseAuth == null
          ? ErrorAndNoNetworkAndFavoriteScreen(
              text: 'no_favorites_yet_info'.tr(),
              path: noFavoriteScreenImage,
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: StreamBuilder<List<Destination>>(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Spinner();
                    } else if (snapshot.connectionState ==
                            ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return ErrorAndNoNetworkAndFavoriteScreen(
                            text: "something_went_wrong_error_msg".tr(),
                            path: errorImage
                            );
                      } else {
                        if (snapshot.hasData && snapshot.data!.isEmpty) {
                          return ErrorAndNoNetworkAndFavoriteScreen(
                            text: 'no_favorites_yet_info'.tr(),
                            path: noFavoriteScreenImage,
                          );
                        } else {
                          return MasonryGridView.count(
                            crossAxisCount: 2,
                            itemCount: snapshot.data!.length,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    DetailScreen.routeName,
                                    arguments: Destination(
                                      id: snapshot.data![index].id,
                                      name: snapshot.data![index].name,
                                      overview: snapshot.data![index].overview,
                                      overviewAz:
                                          snapshot.data![index].overviewAz,
                                      region: snapshot.data![index].region,
                                      regionAz: snapshot.data![index].regionAz,
                                      category: snapshot.data![index].category,
                                      photoUrl: snapshot.data![index].photoUrl,
                                      user: snapshot.data![index].user,
                                      geoPoint: snapshot.data![index].geoPoint,
                                    ),
                                  );
                                },
                                child: StaggeredGridItem(
                                  name: snapshot.data![index].name,
                                  region: snapshot.data![index].region,
                                  regionAz: snapshot.data![index].regionAz,
                                  photo: snapshot.data![index].photoUrl[0],
                                ),
                              );
                            },
                          );
                        }
                      }
                    } else {
                      return ErrorAndNoNetworkAndFavoriteScreen(
                        text: 'no_favorites_yet_info'.tr(),
                        path: noFavoriteScreenImage,
                      );
                    }
                  },
                  stream: FireStoreService().getFavoriteList(),
                ),
              ),
            ),
    );
  }
}
