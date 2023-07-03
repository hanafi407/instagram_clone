import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource sources) async {
  ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: sources);

  if (_file != null) {
    return await _file.readAsBytes();
  }

  print('no image selected');
}

showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}


