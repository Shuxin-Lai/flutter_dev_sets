import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class WSize {
  late double _left;
  late double _right;
  late double _top;
  late double _bottom;

  double get left => _left;
  double get right => _right;
  double get bottom => _bottom;
  double get top => _top;

  WSize({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    _left = left ?? horizontal ?? all ?? 0;
    _right = right ?? horizontal ?? all ?? 0;
    _top = top ?? vertical ?? all ?? 0;
    _bottom = bottom ?? vertical ?? all ?? 0;
  }
}

class WStyleUtils {
  static EdgeInsets getPadding(WSize size) {
    return EdgeInsets.only(
      left: size.left,
      right: size.right,
      top: size.top,
      bottom: size.bottom,
    );
  }

  static double getAdaptiveHeight(double height) {
    return ScreenUtil.getInstance().getHeight(height);
  }

  static double getAdaptiveWidth(double width) {
    return ScreenUtil.getInstance().getWidth(width);
  }

  static double getScreenWidth(BuildContext context, [double scale = 1]) {
    return ScreenUtil.getScreenW(context) * scale;
  }

  static double getScreenHeight(BuildContext context, [double scale = 1]) {
    return ScreenUtil.getScreenH(context) * scale;
  }
}
