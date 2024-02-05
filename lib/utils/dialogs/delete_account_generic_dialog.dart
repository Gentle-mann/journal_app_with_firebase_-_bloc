import 'package:flutter/material.dart';

import 'custom_dialog.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<bool?> showDeleteAccountDialog(BuildContext context) {
  return showCustomDialog<bool?>(
      context: context,
      title: 'Confirm Account Deletion',
      content: 'Are you sure you would like to delete your account?',
      optionsBuilder: () => {
            "OK": true,
            "CANCEL": false,
          }).then((value) => value ?? false);
}
