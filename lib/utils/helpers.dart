// lib/utils/helpers.dart
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makingphonecall(String number) async {
  var _url = Uri.parse("tel:${number}");
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception("Could not launch $_url");
  }
}

Future<File?> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
