import 'package:flutter/material.dart';

abstract class MyState<T extends StatefulWidget> extends State<T> {
  @override
  setState(VoidCallback fn) {
    if (mounted) {
      fn();
    }
  }
}

class MyStateExample extends StatefulWidget {
  const MyStateExample({Key? key}) : super(key: key);

  @override
  State<MyStateExample> createState() => _MyStateExampleState();
}

class _MyStateExampleState extends MyState<MyStateExample> {
  var _flag = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('dispose'),
        onPressed: () {
          Future.delayed(const Duration(seconds: 3000)).whenComplete(() {
            setState(() {
              _flag = !_flag;
            });
          });
          Navigator.pop(context);
          dispose();
        },
      ),
    );
  }
}
