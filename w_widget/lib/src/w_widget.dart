import 'dart:io';

import 'package:flutter/material.dart';
import 'package:w_utils/w_utils.dart';
import 'package:w_widget/src/ok_cancel_content.dart';

enum WConfirmDialogType {
  confirm,
  cancel,
  dismiss,
}

class WWidgetHelpers {
  static Future<WConfirmDialogType> showConfirmDialog(
    BuildContext context, {
    String? title,
    String? confirmText,
    String? cancelText,
    double? width,
    bool isDismissible = true,
    TextStyle? titleTextStyle,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
    bool distinguishCancelAndClose = false,
  }) {
    return WFutureUtils.createFuture<WConfirmDialogType>(
      ({required reject, required resolve}) async {
        if (Platform.isAndroid) {
          await showDialog(
              context: context,
              barrierDismissible: isDismissible,
              builder: (context) {
                return OkCancelContent(
                  title: title,
                  confirmTextStyle: confirmTextStyle,
                  titleTextStyle: titleTextStyle,
                  cancelTextStyle: cancelTextStyle,
                  confirmText: confirmText,
                  cancelText: cancelText,
                  width: width,
                  callback: (type) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    resolve(type);
                  },
                );
              });
        } else {
          await showModalBottomSheet(
              isDismissible: isDismissible,
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return OkCancelContent(
                  title: title,
                  confirmTextStyle: confirmTextStyle,
                  titleTextStyle: titleTextStyle,
                  cancelTextStyle: cancelTextStyle,
                  confirmText: confirmText,
                  cancelText: cancelText,
                  width: width,
                  callback: (type) {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    resolve(type);
                  },
                );
              });
        }
        if (distinguishCancelAndClose) {
          resolve(WConfirmDialogType.dismiss);
        } else {
          resolve(WConfirmDialogType.cancel);
        }
      },
    );
  }
}
