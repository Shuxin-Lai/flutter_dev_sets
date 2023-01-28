import 'package:flutter/material.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as AppleSign;
import 'package:w_utils/w_utils.dart';

class WAppleSignIn extends StatefulWidget {
  const WAppleSignIn({
    Key? key,
    this.userId,
    this.onCredentialRevoked,
    this.beforeAuthorize,
    this.onAuthorize,
    this.onError,
    this.onCancel,
    this.onComplete,
  }) : super(key: key);
  final bool Function()? beforeAuthorize;
  final void Function(AppleSign.AppleIdCredential credential)? onAuthorize;
  final void Function(Object e)? onError;
  final VoidCallback? onCancel;
  final VoidCallback? onComplete;
  final String? userId;
  final VoidCallback? onCredentialRevoked;

  @override
  State<WAppleSignIn> createState() => _WAppleSignInState();
}

class _WAppleSignInState extends State<WAppleSignIn> {
  final Future<bool> _isAvailableFuture =
      AppleSign.TheAppleSignIn.isAvailable();

  @override
  void initState() {
    super.initState();
    checkLoggedInState();

    AppleSign.TheAppleSignIn.onCredentialRevoked?.listen((_) {
      if (widget.onCredentialRevoked != null) {
        widget.onCredentialRevoked!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isAvailableFuture,
        builder: (context, isAvailableSnapshot) {
          return Container(
            child: AppleSign.AppleSignInButton(
              onPressed: () async {
                if (widget.beforeAuthorize != null) {
                  final res = widget.beforeAuthorize!();
                  if (res == false) {
                    return;
                  }
                }

                try {
                  final AppleSign.AuthorizationResult result =
                      await AppleSign.TheAppleSignIn.performRequests([
                    const AppleSign.AppleIdRequest(requestedScopes: [
                      AppleSign.Scope.email,
                      AppleSign.Scope.fullName
                    ])
                  ]);

                  switch (result.status) {
                    case AppleSign.AuthorizationStatus.authorized:
                      if (widget.onAuthorize != null) {
                        widget.onAuthorize!(result.credential!);
                      }
                      break;

                    case AppleSign.AuthorizationStatus.error:
                      if (widget.onError != null) {
                        widget.onError!(result.error!);
                      }
                      break;

                    case AppleSign.AuthorizationStatus.cancelled:
                      if (widget.onCancel != null) {
                        widget.onCancel!();
                      }
                      break;
                  }
                } catch (e) {
                  if (widget.onError != null) {
                    widget.onError!(e);
                  }
                } finally {
                  if (widget.onComplete != null) {
                    widget.onComplete!();
                  }
                }
              },
              type: AppleSign.ButtonType.defaultButton,
              style: AppleSign.ButtonStyle.whiteOutline,
            ),
          );
        });
  }

  void checkLoggedInState() async {
    // final userId = await FlutterSecureStorage().read(key: "userId");
    if (WStringUtils.isEmpty(widget.userId)) {
      print('No stored user ID');
      return;
    }

    final credentialState =
        await AppleSign.TheAppleSignIn.getCredentialState(widget.userId!);
    switch (credentialState.status) {
      case AppleSign.CredentialStatus.authorized:
        print('getCredentialState returned authorized');
        break;

      case AppleSign.CredentialStatus.error:
        print(
            'getCredentialState returned an error: ${credentialState.error?.localizedDescription}');
        break;

      case AppleSign.CredentialStatus.revoked:
        print('getCredentialState returned revoked');
        break;

      case AppleSign.CredentialStatus.notFound:
        print('getCredentialState returned not found');
        break;

      case AppleSign.CredentialStatus.transferred:
        print('getCredentialState returned not transferred');
        break;
    }
  }
}
