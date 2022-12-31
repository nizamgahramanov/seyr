import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:seyr/helper/app_colors.dart';
import 'package:seyr/helper/custom_button.dart';
import 'package:seyr/model/destination_location.dart';
import 'package:seyr/helper/custom_nested_scroll_view.dart';
import 'package:seyr/service/firebase_firestore_service.dart';
import 'package:uuid/uuid.dart';

import '../helper/app_light_text.dart';
import '../helper/utility.dart';
import '../model/destination.dart';
import '../provider/destinations.dart';
import '../helper/custom_text_form_field.dart';
import '../widget/destination_image_picker.dart';
import '../widget/location_input.dart';

const List<String> destinationType = <String>[
  'place',
  'forest',
  'mountain',
  'lake',
  'waterfall'
];

class AddDestinationScreen extends StatefulWidget {
  const AddDestinationScreen({Key? key}) : super(key: key);
  static const routeName = "/add_destination";
  @override
  State<AddDestinationScreen> createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final _addDestinationForm = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _overviewController = TextEditingController();
  final _overviewAzController = TextEditingController();
  final _regionController = TextEditingController();
  final _regionAzController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _overviewFocusNode = FocusNode();
  final _overviewAzFocusNode = FocusNode();
  final _regionFocusNode = FocusNode();
  final _regionAzFocusNode = FocusNode();

  final List<File?> _destinationImageFile = [];
  DestinationLocation? _destinationLocation;

  String dropdownValue = destinationType.first;
  void _saveForm() async {
    final isValid = _addDestinationForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _addDestinationForm.currentState!.save();
    try {
      if (_destinationImageFile.isNotEmpty) {
        var currentUser = FirebaseAuth.instance.currentUser;
        var userData = await FireStoreService().getUserByUid(currentUser!.uid);
        var destinationItem = Destination(
            id: const Uuid().v4(),
            name: _nameController.text,
            overview: _overviewController.text,
            overviewAz: _overviewAzController.text,
            region: _regionController.text,
            regionAz: _regionAzController.text,
            category: dropdownValue,
            photoUrl: _destinationImageFile,
            author:
                '${userData!['firstName'].trim()} ${userData['lastName'].trim()}',
            geoPoint: _destinationLocation != null
                ? GeoPoint(
                    _destinationLocation!.latitude,
                    _destinationLocation!.longitude,
                  )
                : null);

        saveDestinationItem(destinationItem);
      }
    } catch (error) {
      Utility.getInstance().showAlertDialog(
        context: context,
        alertTitle: 'oops_error_title'.tr(),
        alertMessage: 'oops_error_title'.tr(),
        popButtonText: 'ok_btn'.tr(),
        popButtonColor: AppColors.redAccent300,
        onPopTap: () => Navigator.of(context).pop(),
      );
    }
  }

  void saveDestinationItem(Destination destination) {
    Provider.of<Destinations>(context, listen: false)
        .saveData(context, destination, _destinationImageFile);
    Navigator.of(context).pop();
  }

  void pickedImage(List<XFile?> xFileList) {
    for (var xFile in xFileList) {
      _destinationImageFile.add(File(xFile!.path));
    }
  }

  void _selectPlace(double lat, double lng) {
    _destinationLocation = DestinationLocation(latitude: lat, longitude: lng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorOfApp,
      body: CustomNestedScrollView(
        title: 'add_destination'.tr(),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _addDestinationForm,
              child: Column(
                children: [
                  Column(
                    children: [
                      AppLightText(
                        spacing: 2,
                        text: 'name_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        padding: EdgeInsets.zero,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Focus(
                        autofocus: true,
                        onFocusChange: (bool inFocus) {
                          if (inFocus) {
                            FocusScope.of(context).requestFocus(_nameFocusNode);
                          }
                        },
                        child: CustomTextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.name,
                          focusNode: _nameFocusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'destination_name_validation'.tr();
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_overviewAzFocusNode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'overview_az_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _overviewAzController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        focusNode: _overviewAzFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'destination_overview_az_validation'.tr();
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_overviewFocusNode),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'overview'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _overviewController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        focusNode: _overviewFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'destination_overview_validation'.tr();
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_regionAzFocusNode),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'region_az_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _regionAzController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        focusNode: _regionAzFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'destination_region_az_validation'.tr();
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_regionFocusNode),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'region_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        controller: _regionController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        focusNode: _regionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'destination_region_validation'.tr();
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    children: [
                      AppLightText(
                        text: 'category_title'.tr(),
                        size: 18,
                        color: AppColors.blackColor,
                        spacing: 2,
                        padding: EdgeInsets.zero,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: AppColors.primaryColorOfApp,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: dropdownValue,
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: AppColors.primaryColorOfApp,
                              ),
                              style: const TextStyle(
                                  color: AppColors.primaryColorOfApp),
                              onChanged: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                });
                              },
                              items: destinationType
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: AppLightText(
                                    text: value,
                                    padding: EdgeInsets.zero,
                                    spacing: 0,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  DestinationImagePicker(pickedImage),
                  const SizedBox(
                    height: 25,
                  ),
                  LocationInput(_selectPlace, _nameController.text),
                  const SizedBox(
                    height: 90,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomButton(
        onTap: _saveForm,
        buttonText: 'done_btn'.tr(),
        borderRadius: 15,
        horizontalMargin: 20,
        borderColor: AppColors.primaryColorOfApp,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
