import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  const UsernameField({super.key, required this.usernameController});
  final TextEditingController usernameController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: usernameController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
