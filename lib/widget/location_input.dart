import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:seyr/helper/app_light_text.dart';
import 'package:seyr/helper/custom_button.dart';

import '../helper/app_colors.dart';
import '../helper/location_helper.dart';
import '../screen/maps_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  final String destinationName;
  LocationInput(this.onSelectPlace, this.destinationName);
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  bool _isSelecting = true;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _selectOnMap() async {
    Map<String, dynamic> arguments = {
      "isSelecting": _isSelecting,
      "geoPoint": const GeoPoint(40.35412015822521, 47.783417697006065),
      "zoom": 7.0,
      "name": widget.destinationName
    };
    final selectedLocation = await Navigator.of(context).pushNamed(
      MapScreen.routeName,
      arguments: arguments,
    ) as LatLng;
    if (selectedLocation == null) {
      return;
    }
    showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  void showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng, zoom: 7);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 140,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: AppColors.grey,
            ),
          ),
          width: double.infinity,
          child: _previewImageUrl == null
              ? AppLightText(
                  text: 'no_location_chosen'.tr(),
                  padding: EdgeInsets.zero,
                  spacing: 0,
                  alignment: Alignment.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        const SizedBox(
          height: 25,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              onTap: _getCurrentUserLocation,
              buttonText: 'current_location'.tr(),
              borderRadius: 15,
              buttonTextSize: 14,
              height: 45,
              buttonColor: AppColors.transparent,
              textColor: AppColors.blackColor,
              borderColor: AppColors.blackColor,
              textPadding: const EdgeInsets.symmetric(horizontal: 5),
              icon: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.blackColor,
                ),
              ),
            ),
            CustomButton(
              onTap: _selectOnMap,
              buttonText: 'chose_on_map'.tr(),
              borderRadius: 15,
              buttonTextSize: 14,
              height: 45,
              buttonColor: AppColors.transparent,
              textColor: AppColors.blackColor,
              borderColor: AppColors.blackColor,
              textPadding: const EdgeInsets.only(right: 5),
              icon: Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
