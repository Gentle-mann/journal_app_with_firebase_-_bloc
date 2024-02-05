import 'package:firebase_journal_app_with_bloc/services/cloud_service_protocol.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudService implements CloudServiceProtocol {
  @override
  Future<List<Reference>> getPics(String userId) async {
    final pics = await FirebaseStorage.instance.ref(userId).list();
    return pics.items.toList();
  }
}
