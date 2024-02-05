import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_blocs.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingCard(
            iconData: Icons.dark_mode,
            onTap: () {},
            text: 'Dark Mode',
          ),
          SettingCard(
            iconData: Icons.logout,
            onTap: () {
              context.read<AppBloc>().add(const AppEventLogOut());
            },
            text: 'Logout',
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
