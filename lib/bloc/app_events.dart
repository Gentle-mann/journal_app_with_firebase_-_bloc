import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final List<XFile> imageFiles;
  final bool isEdit;

  const AppEventUploadImage({
    required this.imageFiles,
    required this.isEdit,
  });
}

@immutable
class AppEventLogOut implements AppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventInitializeApp implements AppEvent {
  const AppEventInitializeApp();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;
  const AppEventLogin({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;
  const AppEventRegister({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventIsInOverview implements AppEvent {
  final Journal journal;

  const AppEventIsInOverview({
    required this.journal,
  });
}

@immutable
class AppEventIsInAddJournal implements AppEvent {
  final Journal? journal;

  const AppEventIsInAddJournal({
    this.journal,
  });
}

@immutable
class AppEventIsInEditJournal implements AppEvent {
  final Journal? journal;

  const AppEventIsInEditJournal({
    this.journal,
  });
}

@immutable
class AppEventIsInSettings implements AppEvent {
  final Journal? journal;

  const AppEventIsInSettings({
    this.journal,
  });
}

@immutable
class AppEventSavedJournal implements AppEvent {
  final Journal? journal;
  final bool isEdit;

  const AppEventSavedJournal({
    required this.journal,
    required this.isEdit,
  });
}

@immutable
class AppEventGoToHome implements AppEvent {
  const AppEventGoToHome();
}

@immutable
class AppEventDeleteJournal implements AppEvent {
  final String id;

  const AppEventDeleteJournal({
    required this.id,
  });
}

@immutable
class AppEventAddedToBookmark implements AppEvent {
  final Journal journal;

  const AppEventAddedToBookmark({
    required this.journal,
  });
}

@immutable
class AppEventSearchedJournal implements AppEvent {
  final List<Journal> journals;

  const AppEventSearchedJournal({
    required this.journals,
  });
}

@immutable
class AppEventIsInSearch implements AppEvent {
  const AppEventIsInSearch();
}

@immutable
class AppEventExitSearch implements AppEvent {
  const AppEventExitSearch();
}
