# 开发技巧

## 统一 api

### 统一方向 api

## 自定义组件

### 避免组件销毁后 setState

```dart
abstract class MyState<T extends StatefulWidget> extends State<T> {
  @override
  setState(VoidCallback fn) {
    if (mounted) {
      fn();
    }
  }
}
```

### app 生命周期监听

```dart

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
```

## 注意事项

### 状态初始化与状态销毁

1. 先初始化父组件状态，再初始化当前状态。
2. 销毁当前组件副作用，在销毁父组件副作用。

```dart
import 'package:flutter/material.dart';

class InitAndDispose extends StatefulWidget {
  const InitAndDispose({Key? key}) : super(key: key);

  @override
  State<InitAndDispose> createState() => _InitAndDisposeState();
}

class _InitAndDisposeState extends State<InitAndDispose> {
  @override
  void initState() {
    // 先初始化父组件
    super.initState();

    // 再初始化当前组件
    print('init state');
  }

  @override
  void dispose() {
    // 先销毁当前组件副作用
    print('dispose ');

    // 在销毁父组件
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
```
