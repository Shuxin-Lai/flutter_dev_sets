import 'dart:io';

import 'package:w_utils/src/w_type.dart';

class WPlatformUtils {
  static T getPlatformValue<T>({
    required T android,
    required T ios,
  }) {
    return Platform.isAndroid ? android : ios;
  }

  static void platformInvoke({
    VoidFn? android,
    VoidFn? ios,
  }) {
    if (Platform.isAndroid && android != null) {
      android();
    }

    if (Platform.isIOS && ios != null) {
      ios();
    }
  }
}
