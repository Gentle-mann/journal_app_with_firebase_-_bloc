import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/cubits/dark_mode_cubit.dart';
import 'package:firebase_journal_app_with_bloc/utils/dialogs/delete_account_generic_dialog.dart';
import 'package:firebase_journal_app_with_bloc/utils/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_blocs.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<DarkModeCubit>();
    void logout() {
      context.read<AppBloc>().add(const AppEventLogOut());
    }

    void deleteAccount() {
      context.read<AppBloc>().add(const AppEventDeleteAccount());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () {
            context.read<AppBloc>().add(
                  const AppEventGoToHome(),
                );
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: ListView(
        children: [
          SettingCard(
            iconData: themeState.state ? Icons.light_mode : Icons.dark_mode,
            onTap: () {
              context.read<DarkModeCubit>().toggleState();
            },
            text: themeState.state
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode',
          ),
          SettingCard(
            iconData: Icons.logout,
            onTap: () async {
              final confirmedLogout = await showLogoutDialog(context);
              if (confirmedLogout != null) {
                if (confirmedLogout) {
                  logout();
                }
              }
            },
            text: 'Logout',
          ),
          SettingCard(
            onTap: () async {
              final confirmedDelete = await showDeleteAccountDialog(context);
              if (confirmedDelete!) {
                deleteAccount();
              }
            },
            iconData: Icons.person_off_outlined,
            text: 'Delete your account',
          ),
        ],
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  const SettingCard({
    super.key,
    required this.onTap,
    required this.iconData,
    required this.text,
  });
  final VoidCallback onTap;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
