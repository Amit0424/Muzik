import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'get_user_details.dart';

Future<String> takeImage(ImageSource imageSource) async {
  File file;
  final pickedFile = await ImagePicker().pickImage(source: imageSource);

  if (pickedFile == null) return '';

  final dir = await getTemporaryDirectory();
  final targetPath = '${dir.absolute.path}/temp.jpg';
  final result = await FlutterImageCompress.compressAndGetFile(
    pickedFile.path,
    targetPath,
    minHeight: 1080,
    minWidth: 1080,
    quality: 35,
  );
  file = File(result!.path);

  String filePath =
      'listeners/${userId()}/profile_image/${DateTime.now().millisecondsSinceEpoch}';
  await firebaseStorage.ref(filePath).putFile(file);
  final String clickedImageUrl =
      await firebaseStorage.ref(filePath).getDownloadURL();

  return clickedImageUrl;
}
