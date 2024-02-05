import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_journal_app_with_bloc/auth_errors/auth_errors.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_events.dart';
import 'package:firebase_journal_app_with_bloc/bloc/app_states.dart';
import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:firebase_journal_app_with_bloc/services/journal_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../utils/m.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(isLoading: false),
        ) {
    on<AppEventInitializeApp>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } else {
        final journals = _getJournals();
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            journals: journals,
          ),
        );
      }
    });
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      await FirebaseAuth.instance.signOut();
      emit(const AppStateLoggedOut(isLoading: false));
    });
    on<AppEventRegister>((event, emit) async {
      emit(
        const AppStateLoggedOut(isLoading: true),
      );
      try {
        final email = event.email;
        final password = event.password;

        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authenticationError: AuthenticationError.from(e),
          ),
        );
      }
    });

    on<AppEventLogin>((event, emit) async {
      emit(
        const AppStateLoggedOut(isLoading: true),
      );
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user;

        final journals = _getJournals();
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user!,
            journals: journals,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedOut(
          isLoading: false,
          authenticationError: AuthenticationError.from(e),
        ));
      }
    });
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          journals: state.journals ?? const Stream.empty(),
        ),
      );
      try {
        final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
        for (var folderItem in folder.items) {
          print('download url: ${await folderItem.getDownloadURL()}');
          await folderItem.delete().catchError((_) {});
        }
        await user.delete();
        await FirebaseAuth.instance.signOut();
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            journals: state.journals ?? const Stream.empty(),
            authenticationError: AuthenticationError.from(e),
          ),
        );
      } on FirebaseException {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });
    on<AppEventUploadImage>((event, emit) {
      final user = state.user;
      try {
        List images = [];
        for (var i in images) {
          FirebaseStorage.instance
              .ref(user!.uid)
              .child(const Uuid().v4())
              .putFile(i);
        }
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInEditScreen(
            journal: state.journal,
            isLoading: false,
            authenticationError: AuthenticationError.from(e),
          ),
        );
      }
    });
    on<AppEventIsInSettings>((event, emit) {
      emit(
        AppStateIsInSettingsScreen(
          user: state.user!,
          isLoading: false,
        ),
      );
    });
    on<AppEventIsInOverview>((event, emit) {
      emit(
        AppStateIsInOverviewScreen(
          isLoading: false,
          journal: event.journal,
        ),
      );
    });
    on<AppEventIsInAddJournal>((event, emit) {
      emit(
        const AppStateIsInAddScreen(
          isLoading: false,
        ),
      );
    });
    on<AppEventIsInEditJournal>((event, emit) {
      print(state.journal.toString());
      emit(
        AppStateIsInEditScreen(
          journal: event.journal!,
          isLoading: false,
        ),
      );
    });
    on<AppEventSavedJournal>((event, emit) {
      final journal = event.journal;
      emit(
        AppStateIsInOverviewScreen(
          isLoading: false,
          journal: journal ?? Journal.empty(),
        ),
      );

      if (event.isEdit) {
        print(journal!.documentId);
        JournalService().updateJournal(
          journal: journal,
        );
        emit(
          AppStateIsInOverviewScreen(
            isLoading: false,
            journal: journal,
          ),
        );
        return;
      } else {
        JournalService().createJournal(
          journal: journal!,
        );
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: getUser()!,
            journals: _getJournals(),
          ),
        );
      }
    });
    on<AppEventDeleteJournal>((event, emit) {
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: state.user!,
          journals: state.journals ?? const Stream.empty(),
        ),
      );
      JournalService().deleteJournal(documentId: event.id);
      final journals = _getJournals();
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: state.user!,
          journals: journals,
        ),
      );
    });
    on<AppEventGoToHome>((event, emit) {
      final journals = _getJournals();
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: getUser()!,
          journals: journals,
        ),
      );
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getJournals() {
    return JournalService().getJournals();
  }

  @override
  void onChange(Change<AppState> change) {
    super.onChange(change);
    print('Change: $change');
  }

  @override
  void onTransition(Transition<AppEvent, AppState> transition) {
    super.onTransition(transition);
    print('Transition: $transition');
  }
}
