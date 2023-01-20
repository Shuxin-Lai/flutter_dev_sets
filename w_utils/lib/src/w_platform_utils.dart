import 'dart:io';

class WPlatformUtils {
  static T getPlatformValue<T>({
    required T android,
    required T ios,
  }) {
    return Platform.isAndroid ? android : ios;
  }
}
