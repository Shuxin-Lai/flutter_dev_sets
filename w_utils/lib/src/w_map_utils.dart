import 'package:w_utils/src/w_list_utils.dart';

class WMapUtils {
  static bool isMap(dynamic v) {
    return v is Map;
  }

  static bool isNotMap(dynamic v) {
    return isMap(v) == false;
  }

  static bool isEmpty(Map? v) {
    return v == null || v.isEmpty;
  }

  static bool isNotEmpty(Map? v) {
    return isEmpty(v) == false;
  }

  static Map<K, V> merge<K, V>(List<Map<K, V>> maps) {
    if (WListUtils.isEmpty(maps)) {
      return {};
    }
    final res = <K, V>{};

    for (var i = 0; i < maps.length; i++) {
      final map = maps[i];
      res.addAll(map);
    }

    return res;
  }
}
