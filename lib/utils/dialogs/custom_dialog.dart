import 'package:flutter/material.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showCustomDialog<T>(
    {required BuildContext context,
    required String title,
    required String content,
    required DialogOptionsBuilder optionsBuilder}) {
  return showDialog<T?>(
      context: context,
      builder: (context) {
        final options = optionsBuilder();
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: options.keys.map((optionsTitle) {
            final value = options[optionsTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionsTitle),
            );
          }).toList(),
        );
      });
}
