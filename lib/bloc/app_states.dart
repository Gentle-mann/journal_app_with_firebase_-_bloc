import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:flutter/foundation.dart';

import '../auth_errors/auth_errors.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthenticationError? authenticationError;

  const AppState({
    required this.isLoading,
    this.authenticationError,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Stream<QuerySnapshot<Map<String, dynamic>>> journals;

  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.journals,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );

  @override
  bool operator ==(other) {
    final cls = other;
    if (cls is AppStateLoggedIn) {
      return isLoading == cls.isLoading &&
          user.uid == cls.user.uid &&
          journals.length == cls.journals.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(
        user.uid,
        journals,
      );

  @override
  String toString() =>
      'AppStateLoggedIn(user: $user, journals: $journals, error: $authenticationError)';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

@immutable
class AppStateIsInEditScreen extends AppState {
  final Journal journal;
  const AppStateIsInEditScreen({
    required this.journal,
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

@immutable
class AppStateIsInAddScreen extends AppState {
  const AppStateIsInAddScreen({
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

@immutable
class AppStateIsInSettingsScreen extends AppState {
  final User user;
  const AppStateIsInSettingsScreen({
    required this.user,
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

@immutable
class AppStateIsInOverviewScreen extends AppState {
  final Journal journal;
  const AppStateIsInOverviewScreen({
    required this.journal,
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

@immutable
class AppStateSavedJournal extends AppState {
  final User user;
  final Journal journal;
  const AppStateSavedJournal({
    required this.user,
    required this.journal,
    required bool isLoading,
    AuthenticationError? authenticationError,
  }) : super(
          isLoading: isLoading,
          authenticationError: authenticationError,
        );
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetCurrentJournal on AppState {
  Journal get journal {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.journal;
    } else {
      return Journal.empty();
    }
  }
}

extension GetJournals on AppState {
  Stream<QuerySnapshot<Map<String, dynamic>>>? get journals {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.journals;
    } else {
      return null;
    }
  }
}
