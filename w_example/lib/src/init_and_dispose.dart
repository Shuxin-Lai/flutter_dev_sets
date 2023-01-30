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
