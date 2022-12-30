import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/destination.dart';
import '../service/firebase_firestore_service.dart';
import '../service/firebase_storage_service.dart';

class Destinations with ChangeNotifier {
  final firestore_service = FireStoreService();
  final storage_service = FirebaseStorageService();
  var uuid = Uuid();
  final List<Destination> _destinationItems = [];
  Stream<List<Destination>> get destinationItemsAll {
    final allDestination = firestore_service.getDestinations();
    return allDestination;
  }

  Destination findById(String id) {
    return _destinationItems.firstWhere((element) => element.id == id);
  }

  void saveData(BuildContext context, Destination newDestination,
      List<File?> destinationPhoto) async {
    print(newDestination.createMap().toString());
    final urlList = await storage_service.saveDestinationImages(
        context, newDestination, destinationPhoto);
    newDestination.photoUrl = urlList;
    await firestore_service.saveDestination(newDestination);
  }

  Stream<List<Destination>> initSearchDestination(String enteredText) {
    return firestore_service.getDestinationsBySearchText(enteredText);
  }
}
