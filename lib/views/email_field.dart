import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.emailController});
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
