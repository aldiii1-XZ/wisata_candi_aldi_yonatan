import 'package:flutter/material.dart';

ImageProvider<Object> buildPlatformProfileImage(String? path) {
  if (path != null && path.isNotEmpty) {
    return NetworkImage(path);
  }
  return const AssetImage('images/placeholder_image.png');
}
