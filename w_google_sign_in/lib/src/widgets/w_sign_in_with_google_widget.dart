import 'package:flutter/material.dart';
import 'package:w_google_sign_in/src/w_google_sign_in.dart';
import 'package:w_google_sign_in/src/widgets/login_button.dart';

class WSigInWithGoogleWidget extends StatelessWidget {
  WSigInWithGoogleWidget({Key? key, this.onPressed}) : super(key: key);
  final Future _isAvailableFuture = WGoogleSignIn.initFireBase();
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isAvailableFuture,
        builder: (context, isAvailableSnapshot) {
          return LoginButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed!();
              }
            },
          );
        });
  }
}
