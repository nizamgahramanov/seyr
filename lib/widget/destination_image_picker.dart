import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seyr/helper/custom_button.dart';

import '../helper/app_colors.dart';

class DestinationImagePicker extends StatefulWidget {
  DestinationImagePicker(this.imagePickFn);
  final void Function(List<XFile?> pickedImage) imagePickFn;

  @override
  State<DestinationImagePicker> createState() => _DestinationImagePickerState();
}

class _DestinationImagePickerState extends State<DestinationImagePicker> {
  List<XFile?> pickedImages = [];

  final ImagePicker imagePicker = ImagePicker();

  void _pickImage() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage(
      imageQuality: 100,
      maxWidth: 800,
      maxHeight: 800,
    );
    setState(() {
      if (selectedImages.isNotEmpty) {
        pickedImages.addAll(selectedImages);
      }
    });

    widget.imagePickFn(pickedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
          onTap: _pickImage,
          buttonText: 'add_photo'.tr(),
          borderRadius: 15,
          buttonColor: AppColors.transparent,
          textColor: AppColors.blackColor,
          borderColor: AppColors.blackColor,
          icon: Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 25),
            child: const Icon(Icons.photo_camera),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          height: 80,
          width: double.maxFinite,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pickedImages.length,
              itemBuilder: (BuildContext ctx, index) {
                return CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.grey,
                  child: CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.grey,
                      backgroundImage: pickedImages.isNotEmpty
                          ? FileImage(File(pickedImages[index]!.path))
                          : null),
                );
              }),
        ),
      ],
    );
  }
}
