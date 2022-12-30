import 'package:cloud_firestore/cloud_firestore.dart';

class Destination {
  final String? id;
  final String name;
  final String overview;
  final String overviewAz;
  final String region;
  final String regionAz;
  final String category;
  final GeoPoint? geoPoint;
  final String author;
  List<dynamic> photoUrl;

  Destination({
    required this.id,
    required this.name,
    required this.overview,
    required this.overviewAz,
    required this.region,
    required this.regionAz,
    required this.category,
    required this.photoUrl,
    required this.author,
    this.geoPoint,
  });
  Map<String, dynamic> createMap() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'overview_az': overviewAz,
      'region': region,
      'region_az': regionAz,
      'category': category,
      'photo_url': photoUrl,
      'author': author,
      'geoPoint': geoPoint,
    };
  }

  Destination.fromFirestore(Map<String, dynamic> firestoreMap)
      : id = firestoreMap['id'],
        name = firestoreMap['name'],
        overview = firestoreMap['overview'],
        overviewAz = firestoreMap['overview_az'],
        region = firestoreMap['region'],
        regionAz = firestoreMap['region_az'],
        category = firestoreMap['category'],
        photoUrl = firestoreMap['photo_url'].cast<String>(),
        author = firestoreMap['author'],
        geoPoint = firestoreMap['geoPoint'];
}
