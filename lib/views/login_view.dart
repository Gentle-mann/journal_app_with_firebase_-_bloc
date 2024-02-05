import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/extensions/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/enums/auth_state_enum.dart';
import '../utils/dialogs/custom_dialog.dart';
import 'custom_button.dart';
import 'email_field.dart';
import 'password_field.dart';
import 'username_field.dart';

typedef OnPressed = void Function(String email, String password);

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController emailController =
      TextEditingController(text: 'khalifa1000@gmail.com'.ifDebugging);
  late final TextEditingController passwordController =
      TextEditingController(text: '123456'.ifDebugging);
  late final TextEditingController usernameController =
      TextEditingController(text: 'khalifa'.ifDebugging);
  AuthState authState = AuthState.login;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
        ),
      ),
      body: Column(
        children: [
          RadioListTile(
            title: const Text('Register'),
            value: AuthState.register,
            groupValue: authState,
            onChanged: ((value) {
              setState(() {
                authState = AuthState.register;
              });
            }),
          ),
          if (authState == AuthState.register)
            Column(
              children: [
                UsernameField(
                  usernameController: usernameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                EmailField(
                  emailController: emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                PasswordField(
                  passwordController: passwordController,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Register',
                  onPressed: () {
                    context.read<AppBloc>().add(
                          AppEventRegister(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                      
                    setState(() {
                      authState = AuthState.login;
                    });
                  },
                ),
              ],
            ),
          RadioListTile.adaptive(
            title: const Text('Login'),
            value: AuthState.login,
            groupValue: authState,
            onChanged: (value) {
              setState(() {
                authState = AuthState.login;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          if (authState == AuthState.login)
            Column(
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
            )
        ],
      ),
    );
  }
}
