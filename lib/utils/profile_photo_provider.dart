import 'profile_photo_provider_io.dart'
    if (dart.library.html) 'profile_photo_provider_web.dart';

import 'package:flutter/material.dart';

ImageProvider<Object> buildProfileImageProvider(String? path) =>
    buildPlatformProfileImage(path);
