import 'dart:io';

import 'package:flutter/material.dart';
import 'package:w_utils/w_utils.dart';
import 'package:w_widget/src/w_column.dart';
import 'package:w_widget/src/w_divider.dart';
import 'package:w_widget/src/w_font_size.dart';
import 'package:w_widget/src/w_widget_helpers.dart';

typedef Callback = Function(WConfirmDialogType);

class OkCancelContent extends StatefulWidget {
  OkCancelContent({
    Key? key,
    String? title,
    String? confirmText,
    String? cancelText,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
    TextStyle? titleTextStyle,
    double? width,
    EdgeInsets? padding,
    this.callback,
  }) : super(key: key) {
    this.title = title ?? 'Are you sure to delete this item?';
    this.confirmText = confirmText ?? 'Confirm';
    this.cancelText = cancelText ?? 'Cancel';
    this.width = width ?? WStyleUtils.getAdaptiveWidth(305);

    this.padding = padding ??
        EdgeInsets.symmetric(vertical: WStyleUtils.getAdaptiveHeight(12));

    this.titleTextStyle = titleTextStyle ??
        WPlatformUtils.getPlatformValue(
          android: TextStyle(
            fontSize: WFontSize.normal,
          ),
          ios: TextStyle(
            fontSize: WFontSize.small,
            color: Colors.grey.shade600,
          ),
        );

    this.confirmTextStyle = confirmTextStyle ??
        WPlatformUtils.getPlatformValue(
          android: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.red,
          ),
          ios: TextStyle(
            color: Colors.red,
            fontSize: WFontSize.normal,
          ),
        );

    this.cancelTextStyle = cancelTextStyle ??
        WPlatformUtils.getPlatformValue(
            android: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            ios: TextStyle(
              fontSize: WFontSize.normal,
              color: Colors.black54,
            ));
  }

  late String title;
  late String confirmText;
  late String cancelText;
  late double width;
  late EdgeInsets padding;
  late TextStyle titleTextStyle;
  late TextStyle confirmTextStyle;
  late TextStyle cancelTextStyle;
  final Callback? callback;

  @override
  State<OkCancelContent> createState() => _OkCancelContentState();
}

class ScreenUtil {}

class _OkCancelContentState extends State<OkCancelContent> {
  Widget _buildAndroid(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WStyleUtils.getAdaptiveWidth(8)),
        ),
        child: Wrap(
          children: [
            WColumn(
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: 4,
              children: [
                MediaQuery.removePadding(
                  removeBottom: true,
                  removeTop: true,
                  context: context,
                  child: Container(
                    padding: widget.padding,
                    width: double.infinity,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: widget.titleTextStyle,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (widget.callback != null) {
                            widget.callback!(WConfirmDialogType.cancel);
                          }
                        },
                        child: Container(
                          padding: widget.padding,
                          width: double.infinity,
                          child: Text(
                            widget.cancelText,
                            textAlign: TextAlign.center,
                            style: widget.cancelTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (widget.callback != null) {
                          widget.callback!(WConfirmDialogType.confirm);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: widget.padding,
                        child: Text(
                          widget.confirmText,
                          textAlign: TextAlign.center,
                          style: widget.confirmTextStyle,
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: WStyleUtils.getAdaptiveHeight(6),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: WStyleUtils.getAdaptiveWidth(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xffefeff1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: widget.padding,
                      margin: WStyleUtils.getPadding(WSize(
                        horizontal: WStyleUtils.getAdaptiveWidth(8),
                      )),
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: widget.titleTextStyle,
                      ),
                    ),
                    WDivider(
                      color: Colors.grey.shade300,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.callback != null) {
                          widget.callback!(WConfirmDialogType.confirm);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: widget.padding,
                        child: Text(
                          widget.confirmText,
                          textAlign: TextAlign.center,
                          style: widget.confirmTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.callback != null) {
                    widget.callback!(WConfirmDialogType.cancel);
                  }
                },
                child: Container(
                  padding: widget.padding,
                  decoration: BoxDecoration(
                    color: const Color(0xffefeff1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  width: double.infinity,
                  child: Text(
                    widget.cancelText,
                    textAlign: TextAlign.center,
                    style: widget.cancelTextStyle,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return _buildAndroid(context);
    }
    return _buildIos(context);
  }
}
