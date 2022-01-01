import 'package:flutter/foundation.dart';

bool get isWebMobile =>
    kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android);
