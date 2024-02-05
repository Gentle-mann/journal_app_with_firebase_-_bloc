import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CloudServiceProtocol {
  Future<List<Reference>> getPics(String userId);
}
