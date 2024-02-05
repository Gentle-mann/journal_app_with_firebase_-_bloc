import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_blocs.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_states.dart';
import 'package:firebase_journal_app_with_bloc/firebase_options.dart';
import 'package:firebase_journal_app_with_bloc/loading/loading_dialog.dart';
import 'package:firebase_journal_app_with_bloc/utils/dialogs/auth_error_dialog.dart';
import 'package:firebase_journal_app_with_bloc/views/journal_overview.dart';
import 'package:firebase_journal_app_with_bloc/views/journals_list_view.dart';
import 'package:firebase_journal_app_with_bloc/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/add_edit_journal_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitializeApp()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Jumprack',
        theme: ThemeData(
          brightness: Brightness.dark,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            }
            if (appState is AppStateLoggedIn) {
              return const JournalsListView();
            } else if (appState is AppStateIsInEditScreen) {
              return AddEditJournalView(
                isEdit: true,
                journal: appState.journal,
              );
            } else if (appState is AppStateIsInAddScreen) {
              return AddEditJournalView(
                isEdit: false,
                journal: appState.journal,
              );
            } else if (appState is AppStateIsInOverviewScreen) {
              return JournalOverview(
                journal: appState.journal,
              );
            } else {
              return Container();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingDialog.instance().showOverlayDialog(
                context: context,
                message: 'Please wait',
              );
            } else {
              LoadingDialog.instance().hideDialog();
            }
            if (appState.authenticationError != null) {
              print(appState.authenticationError!.errorContent);
              showAuthErrorDialog(
                context: context,
                authenticationError: appState.authenticationError!,
              );
            }
          },
        ),
      ),
    );
  }
}
