import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

typedef Integer = Map<String?, double>;

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
  static T _g<T>({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    final _left = left ?? horizontal ?? all ?? 0;
    final _right = right ?? horizontal ?? all ?? 0;
    final _top = top ?? vertical ?? all ?? 0;
    final _bottom = bottom ?? vertical ?? all ?? 0;

    if (T is EdgeInsets) {
      return EdgeInsets.only(
          left: _left, right: _right, bottom: _bottom, top: _top) as T;
    }

    throw ErrorDescription('Invalid type');
  }

  static EdgeInsets getEdgeInsets({
    double? all,
    double? left,
    double? right,
    double? top,
    double? bottom,
    double? vertical,
    double? horizontal,
  }) {
    return _g<EdgeInsets>(
        all: all,
        left: left,
        right: right,
        bottom: bottom,
        top: top,
        vertical: vertical,
        horizontal: horizontal);
  }

  @Deprecated('Use [getEdgeInsets]')
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

  static double getSp(double fontSize) {
    return ScreenUtil.getInstance().getSp(fontSize);
  }
}
