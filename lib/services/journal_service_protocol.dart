import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:flutter/material.dart';

@immutable
abstract class JournalServiceProtocol {
  void deleteJournal({required String documentId});
  void updateJournal({
    required Journal journal,
  });
  Future<void> createJournal({
    required Journal journal,
  });
  Stream<QuerySnapshot> getJournals();
}
