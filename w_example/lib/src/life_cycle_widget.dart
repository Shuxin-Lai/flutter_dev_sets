import 'package:flutter/material.dart';

class LifeCycleWidget extends StatefulWidget {
  const LifeCycleWidget({Key? key, required this.child, this.listener})
      : super(key: key);

  final Widget child;
  final void Function(AppLifecycleState state)? listener;

  @override
  State<LifeCycleWidget> createState() => _LifeCycleWidgetState();
}

class _LifeCycleWidgetState extends State<LifeCycleWidget>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.listener != null) {
      widget.listener!(state);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
