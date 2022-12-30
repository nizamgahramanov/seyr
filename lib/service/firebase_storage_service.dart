import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../helper/app_colors.dart';
import '../helper/utility.dart';
import '../model/destination.dart';

class FirebaseStorageService {
  final ref = FirebaseStorage.instance;

  Future<List<String>> saveDestinationImages(BuildContext context,
      Destination destination, List<File?> destinationPhoto) async {
    int i = 0;
    final List<String> returnedListOfPath = [];
    for (File? imageFile in destinationPhoto) {
      try {
        final fileRef = ref
            .ref()
            .child((destination.id).toString())
            .child("${destination.name}_$i.jpg");

        await fileRef.putFile(imageFile!);

        var url = await fileRef.getDownloadURL();

        returnedListOfPath.add(url);

        i++;
      } catch (error) {
        Utility.getInstance().showAlertDialog(
          context: context,
          alertTitle: 'oops_error_title'.tr(),
          alertMessage: 'unknown_error_msg'.tr(),
          popButtonText: 'ok_btn'.tr(),
          popButtonColor: AppColors.redAccent300,
          onPopTap: () => Navigator.of(context).pop(),
        );
      }
    }
    return returnedListOfPath;
  }
}
