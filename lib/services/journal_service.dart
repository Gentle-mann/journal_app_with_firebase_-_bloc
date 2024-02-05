import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_journal_app_with_bloc/models/journal_model.dart';
import 'package:firebase_journal_app_with_bloc/services/journal_service_protocol.dart';

class JournalService implements JournalServiceProtocol {
  final journalsCollection = FirebaseFirestore.instance.collection('journals');
  @override
  Future<void> createJournal({
    required Journal journal,
  }) async {
    await journalsCollection
        .add(journal.toMap())
        .then((value) => print('create true'))
        .catchError((e, s) {
      print('error: $e');
    });
  }

  @override
  void deleteJournal({required String documentId}) {
    journalsCollection.doc(documentId).delete();
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getJournals() {
    return journalsCollection.snapshots().handleError((e, s) {
      print('errro: $e');
    });
  }

  @override
  void updateJournal({required Journal journal}) {
    journalsCollection
        .doc(journal.documentId)
        .update(journal.toMap())
        .catchError((e, s) {
      print(e.toString());
    });
  }
}
