import 'package:flutter/material.dart';

import 'custom_dialog.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<bool?> showLogoutDialog(BuildContext context) {
  return showCustomDialog<bool?>(
      context: context,
      title: 'Log out confirmation',
      content: 'Are you sure you would like to logout?',
      optionsBuilder: () => {
            "Cancel": false,
            "Log out": true,
          }).then(
    (value) => value ?? false,
  );
}
