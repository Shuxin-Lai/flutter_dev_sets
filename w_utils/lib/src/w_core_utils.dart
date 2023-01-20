typedef WSafeInvokeFn = dynamic Function();

class WCoreUtils {
  static void safeInvoke(dynamic Function() fn) {
    try {
      final res = fn();
      if (res is Future) {
        res.catchError((err) {
          print(
              'WCoreUtils.safeInvoke: catch a async error: ${err.toString()}');
        });
      }
    } catch (err) {
      print('WCoreUtils.safeInvoke: catch an error: ${err.toString()}');
    }
  }
}
