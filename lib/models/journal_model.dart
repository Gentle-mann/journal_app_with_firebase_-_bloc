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

  const Journal({
    required this.text,
    required this.dateTime,
    required this.color,
    required this.documentId,
    required this.userId,
    required this.images,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'documentId': documentId,
      'userId': userId,
      'images': images,
      'text': text,
      'dateTime': dateTime,
      'color': color,
    };
  }

  Journal.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentId = snapshot.id,
        userId = snapshot.data()["userId"],
        text = snapshot.data()["text"] as String,
        images = snapshot.data()["images"] as List<dynamic>,
        color = snapshot.data()["color"] as String,
        dateTime = snapshot.data()["dateTime"] as String;

  static final journals = [
    Journal(
      text: 'Today, I went to the beach with my parents. I had a lot of fun',
      dateTime: DateTime.now().subtract(const Duration(days: 1)).toString(),
      color: 'ff0000',
      documentId: '',
      userId: '',
      images: [],
    ),
  ];
  Journal.empty()
      : documentId = '',
        userId = '',
        images = [],
        text = '',
        dateTime = DateTime.now().toString(),
        color = '';
  Journal copyWith({
    String? documentId,
    String? userId,
    List<String>? images,
    String? text,
    String? dateTime,
    String? color,
  }) {
    return Journal(
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      images: images ?? this.images,
      text: text ?? this.text,
      dateTime: dateTime ?? this.dateTime,
      color: color ?? this.color,
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
