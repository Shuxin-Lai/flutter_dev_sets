import 'package:flutter/material.dart';
import 'package:w_utils/w_utils.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, required this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          side: const BorderSide(color: Colors.black),
          padding:
              EdgeInsets.symmetric(vertical: WStyleUtils.getAdaptiveWidth(14))),
      onPressed: () {
        onPressed();
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'images/g-logo.png',
          width: 24,
        ),
        Container(
          padding: EdgeInsets.only(right: WStyleUtils.getAdaptiveWidth(6)),
        ),
        Text(
          'Sign in with Google',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: WStyleUtils.getSp(16)),
        )
      ]),
    );
  }
}
