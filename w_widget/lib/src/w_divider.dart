import 'package:flutter/material.dart';

enum WDividerDirection {
  vertical,
  horizontal,
}

class WDivider extends StatelessWidget {
  WDivider({
    Key? key,
    Color? color,
    this.size = 1,
    this.direction = WDividerDirection.horizontal,
  }) : super(key: key) {
    this.color = color ?? Colors.grey.shade700;
  }
  final double size;
  late Color color;
  final WDividerDirection direction;

  @override
  Widget build(BuildContext context) {
    if (direction == WDividerDirection.vertical) {
      return Container(
        width: size,
        color: color,
      );
    }
    return Container(
      height: size,
      color: color,
    );
  }
}
