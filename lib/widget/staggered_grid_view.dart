import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/custom_tab_indicator.dart';
import 'package:seyr/screen/error_and_no_network_and_favorite_screen.dart';
import 'package:seyr/widget/network_connection_checker.dart';
import 'package:seyr/widget/spinner.dart';
import 'package:seyr/widget/staggered_grid_item.dart';

import '../helper/constants.dart';
import '../model/destination.dart';
import '../provider/destinations.dart';
import '../screen/detail_screen.dart';

class StaggeredGridView extends StatefulWidget {
  @override
  State<StaggeredGridView> createState() => _StaggeredGridViewState();
}

enum DestinationCategory {
  waterfall,
  mountain,
  lake,
  place,
  forest,
}

class _StaggeredGridViewState extends State<StaggeredGridView>
    with TickerProviderStateMixin {
  var tabNames = [
    {DestinationCategory.place: 'place_tab'.tr()},
    {DestinationCategory.forest: 'forest_tab'.tr()},
    {DestinationCategory.lake: 'lake_tab'.tr()},
    {DestinationCategory.waterfall: 'waterfall_tab'.tr()},
    {DestinationCategory.mountain: 'mountain_tab'.tr()},
  ];

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<Destinations>(context);
    TabController tabController =
        TabController(length: tabNames.length, vsync: this);
    return StreamBuilder<List<Destination>>(
        stream: providerData.destinationItemsAll,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Spinner();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorAndNoNetworkAndFavoriteScreen(
                text: 'something_went_wrong_error_msg'.tr(),
                path: errorImage,
              );
            } else {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      labelPadding: const EdgeInsets.only(right: 20),
                      unselectedLabelColor: AppColors.blackColor38,
                      labelColor: AppColors.primaryColorOfApp,
                      controller: tabController,
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: const CustomTabIndicator(
                        color: AppColors.primaryColorOfApp,
                        isCircle: false,
                      ),
                      tabs: tabNames
                          .map(
                            (e) => Tab(
                              child: Text(
                                e.values.first,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: tabNames.map((e) {
                        Iterable<Destination> destinationIterable =
                            snapshot.data!.where((element) =>
                                element.category == e.keys.first.name);
                        return NetworkConnectionChecker(
                          child: MasonryGridView.count(
                            crossAxisCount: 2,
                            itemCount: destinationIterable.length,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  DetailScreen.routeName,
                                  arguments:
                                      destinationIterable.elementAt(index),
                                );
                              },
                              child: StaggeredGridItem(
                                name: destinationIterable.elementAt(index).name,
                                region:
                                    destinationIterable.elementAt(index).region,
                                regionAz: destinationIterable
                                    .elementAt(index)
                                    .regionAz,
                                photo: destinationIterable
                                    .elementAt(index)
                                    .photoUrl[0],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }
          } else {
            return ErrorAndNoNetworkAndFavoriteScreen(
              text: 'something_went_wrong_error_msg'.tr(),
              path: errorImage,
            );
          }
        });
  }
}
