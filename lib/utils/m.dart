import 'package:firebase_auth/firebase_auth.dart';

User? getUser() {
  return FirebaseAuth.instance.currentUser;
}
