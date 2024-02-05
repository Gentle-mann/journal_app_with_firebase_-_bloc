import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/app_blocs.dart';
import '../utils/dialogs/custom_dialog.dart';
import 'custom_button.dart';
import 'email_field.dart';
import 'password_field.dart';

class RegistrationView extends HookWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'ishaqibrahim017@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: '123456'.ifDebugging);
    return Column(
      children: [
        EmailField(
          emailController: emailController,
        ),
        const SizedBox(
          height: 10,
        ),
        PasswordField(
          passwordController: passwordController,
        ),
        CustomButton(
          text: 'Login',
          onPressed: () {
            if (emailController.text.isEmpty ||
                passwordController.text.isEmpty) {
              showCustomDialog(
                context: context,
                title: 'Empty email or password',
                content: 'You need to fill in your email and password',
                optionsBuilder: () => {
                  "OK": true,
                },
              );
            } else {
              context.read<AppBloc>().add(
                    AppEventLogin(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    ),
                  );
            }
          },
        ),
      ],
    );
  }
}
