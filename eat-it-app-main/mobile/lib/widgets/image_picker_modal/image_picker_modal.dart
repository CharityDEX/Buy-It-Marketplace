import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:eat_it/providers/local_photo/local_photo.dart';
import 'package:eat_it/widgets/button/button.dart';
import 'package:eat_it/widgets/permissions/permission_request_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerModal extends ConsumerStatefulWidget {
  const ImagePickerModal({super.key});

  @override
  ConsumerState<ImagePickerModal> createState() => ImagePickerModalState();
}

class ImagePickerModalState extends ConsumerState<ImagePickerModal> {
  final ImagePicker picker = ImagePicker();

  dynamic Function() pickImage(ImageSource source) {
    return () async {
      final XFile? image = await picker.pickImage(
          source: source, preferredCameraDevice: CameraDevice.front);

      if (image == null) {
        return null;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
              hideBottomControls: true,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
              aspectRatioLockEnabled: false,
              aspectRatioLockDimensionSwapEnabled: false,
              aspectRatioPickerButtonHidden: true,
              title: 'Cropper',
              doneButtonTitle: 'Done',
              cancelButtonTitle: 'Cancel'),
        ],
      );

      if (croppedFile == null) {
        return null;
      }

      final compressedImage = await FlutterImageCompress.compressWithFile(
        croppedFile.path,
        rotate: 0,
        quality: 25,
        keepExif: false,
        autoCorrectionAngle: true,
        format: CompressFormat.jpeg,
      );

      if (compressedImage == null) {
        return null;
      }

      final imageData = base64Encode(compressedImage);

      ref.read(localPhoto.notifier).update((state) => state = imageData);

      if (context.mounted) Navigator.pop(context);
    };
  }

  Widget buildGalleryButton() {
    if (Platform.isIOS) {
      return PermissionRequestButton(
        buttonText: "edit-profile.modal.button1".tr(),
        buttonTheme: ButtonThemeMode.accountActions,
        onPressed: pickImage(ImageSource.gallery),
        permissionMessage: "permissions.gallery".tr(),
        permission: Permission.photos,
      );
    }

    return Button(
      text: "edit-profile.modal.button1".tr(),
      mode: ButtonThemeMode.accountActions,
      onPressed: pickImage(ImageSource.gallery),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildGalleryButton(),
            const SizedBox(height: 12),
            PermissionRequestButton(
              buttonText: "edit-profile.modal.button2".tr(),
              buttonTheme: ButtonThemeMode.accountActions,
              permissionMessage: "permissions.camera".tr(),
              permission: Permission.camera,
              onPressed: pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 12),
            Button(
              text: "edit-profile.modal.button3".tr(),
              mode: ButtonThemeMode.secondary,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      )
    ]);
  }
}
