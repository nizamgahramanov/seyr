import 'dart:convert';

import 'package:http/http.dart' as http;

import 'constants.dart';


class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
    required double zoom,
  }) {
    return '${googleBasePart}staticmap?center=$latitude,$longitude&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKey';
  }

  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        '${googleBasePart}geocode/json?latlng=$lat,$lng&key=$googleApiKey');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
  }
}
