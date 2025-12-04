import 'dart:io';

import 'package:flutter/material.dart';

ImageProvider<Object> buildPlatformProfileImage(String? path) {
  if (path != null) {
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
  }
  return const AssetImage('images/placeholder_image.png');
}
