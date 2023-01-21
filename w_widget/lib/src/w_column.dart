import 'package:flutter/material.dart';
import 'package:w_utils/w_utils.dart';

class WColumn extends StatelessWidget {
  WColumn({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline, // NO DEFAULT: we don't know what the text's baseline should be
    this.children = const <Widget>[],
    this.gap = 0,
  }) : super(key: key);

  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    var _children = children;
    if (gap != 0 && WListUtils.isNotEmpty(children)) {
      _children = [];
      WListUtils.forEach<Widget>(children, (element, index) {
        _children.add(element);

        if (index + 1 != children.length) {
          _children.add(Container(
            height: gap,
          ));
        }
      });
    }

    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textBaseline: textBaseline,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      children: _children,
    );
  }
}
