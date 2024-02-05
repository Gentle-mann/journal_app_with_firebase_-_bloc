import 'package:flutter/material.dart';

import '../../auth_errors/auth_errors.dart';
import 'custom_dialog.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<bool?> showAuthErrorDialog({
  required BuildContext context,
  required AuthenticationError authenticationError,
}) {
  // String? unknownError;
  // if (authError is AuthErrorUnknown) {
  //   unknownError = authError.unknownException.code;
  //   print('internal error: $unknownError');
  // }
  return showCustomDialog<bool?>(
      context: context,
      title: authenticationError.errorTitle,
      content: '${authenticationError.errorContent}. ',
      optionsBuilder: () => {
            "OK": false,
          }).then(
    (value) => value ?? false,
  );
}
