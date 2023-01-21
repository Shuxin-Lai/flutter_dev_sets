class WFunctionUtils {
  static bool isFunction(dynamic v) {
    return v is Function;
  }

  static bool isNotFunction(dynamic v) {
    return isFunction(v) == false;
  }
}
