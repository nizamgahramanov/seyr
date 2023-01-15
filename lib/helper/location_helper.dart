import 'constants.dart';
import 'dart:io' show Platform;

class LocationHelper {
  static String? generateLocationPreviewImage({
    required double latitude,
    required double longitude,
    required double zoom,
  }) {
    if (Platform.isAndroid) {
      return '${googleBasePart}staticmap?center=$latitude,$longitude&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKeyAndroid';
    } else if (Platform.isIOS) {
      return '${googleBasePart}staticmap?center=$latitude,$longitude&zoom=$zoom&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$googleApiKeyIos';
    }
    return null;
  }
}
