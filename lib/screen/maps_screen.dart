import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/app_light_text.dart';

class MapScreen extends StatefulWidget {
  final bool isSelecting;
  static const routeName = "/map_screen";
  MapScreen({this.isSelecting = false});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final geoPointArgument = data['geoPoint'] as GeoPoint;
    return Scaffold(
      appBar: AppBar(
        title: AppLightText(
          text: data['name'],
          padding: EdgeInsets.zero,
          spacing: 0,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.bold,
          size: 18,
        ),
        actions: [
          if (data["isSelecting"])
            IconButton(
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(geoPointArgument.latitude, geoPointArgument.longitude),
          zoom: data['zoom'],
        ),
        onLongPress: data['isSelecting'] ? _selectLocation : null,
        markers: (_pickedLocation == null && data['isSelecting'] == true)
            ? {}
            : {
                Marker(
                  markerId: const MarkerId('m1'),
                  position: _pickedLocation ??
                      LatLng(geoPointArgument.latitude,
                          geoPointArgument.longitude),
                ),
              },
      ),
    );
  }
}
