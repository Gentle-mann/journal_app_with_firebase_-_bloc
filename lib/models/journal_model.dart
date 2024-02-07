// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Journal {
  final String documentId;
  final String userId;
  final List<dynamic> images;
  final String text;
  final String dateTime;
  final String color;
  final bool isBookmarked;

  const Journal({
    required this.text,
    required this.dateTime,
    required this.color,
    required this.documentId,
    required this.userId,
    required this.images,
    required this.isBookmarked,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentId': documentId,
      'userId': userId,
      'images': images,
      'text': text,
      'dateTime': dateTime,
      'color': color,
      'isBookMarked': isBookmarked,
    };
  }

  Journal.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentId = snapshot.id,
        userId = snapshot.data()["userId"] as String,
        text = snapshot.data()["text"] as String,
        images = snapshot.data()["images"] as List<dynamic>,
        color = snapshot.data()["color"] as String,
        dateTime = snapshot.data()["dateTime"] as String,
        isBookmarked = snapshot.data()["isBookmarked"] ?? false;

  Journal.fromDocumentSnapshot(DocumentSnapshot snapshot)
      : documentId = snapshot.id,
        userId = snapshot.get("userId") as String,
        text = snapshot.get("text") as String,
        images = snapshot.get("images") as List<dynamic>,
        color = snapshot.get("color") as String,
        dateTime = snapshot.get("dateTime") as String,
        isBookmarked = snapshot.get("isBookmarked") ?? false;

  Journal.empty()
      : documentId = '',
        userId = '',
        images = [],
        text = '',
        dateTime = DateTime.now().toString(),
        color = '',
        isBookmarked = false;
  Journal copyWith({
    String? documentId,
    String? userId,
    List<String>? images,
    String? text,
    String? dateTime,
    String? color,
    bool? isBookmarked,
  }) {
    return Journal(
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      color: color ?? this.color,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(
      documentId: map['documentId'] as String,
      userId: map['userId'] as String,
      images: List<String>.from((map['images'] as List<String>)),
      text: map['text'] as String,
      dateTime: map['dateTime'] as String,
      color: map['color'] as String,
      isBookmarked: map['isBookmarked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Journal.fromJson(String source) =>
      Journal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Journal(documentId: $documentId, userId: $userId, images: $images, text: $text, dateTime: $dateTime, color: $color)';
  }

  @override
  bool operator ==(covariant Journal other) {
    if (identical(this, other)) return true;

    return other.documentId == documentId &&
        other.userId == userId &&
        listEquals(other.images, images) &&
        other.text == text &&
        other.dateTime == dateTime &&
        other.color == color;
  }

  @override
  int get hashCode {
    return documentId.hashCode ^
        userId.hashCode ^
        images.hashCode ^
        text.hashCode ^
        dateTime.hashCode ^
        color.hashCode;
  }
}
