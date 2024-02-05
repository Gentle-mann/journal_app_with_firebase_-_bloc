import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key, required this.passwordController});
  final TextEditingController passwordController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
